import 'dart:convert';

/// Extracts a short, display-safe message from API responses of any content type.
///
/// APIs should normally return JSON, but gateways and web servers sometimes
/// return HTML or plain text. Keeping this conversion at the network boundary
/// gives every repository the same error-message behavior.
class ApiResponseMessage {
  const ApiResponseMessage._();

  static const int _maxMessageLength = 300;
  static const List<String> _messageKeys = <String>[
    'message',
    'error_description',
    'error',
    'detail',
    'title',
    'reason',
  ];

  static String extract({
    required dynamic data,
    String? contentType,
    int? statusCode,
    String? statusMessage,
  }) {
    final bodyMessage = _fromValue(data, contentType: contentType);
    if (bodyMessage != null) return bodyMessage;

    final reason = _cleanText(statusMessage);
    if (reason != null) return reason;

    return statusCode == null ? 'Request failed' : 'HTTP $statusCode';
  }

  /// Keeps JSON error fields intact while ensuring legacy repositories can
  /// safely parse non-JSON error responses as a map.
  static Map<String, dynamic> normalizeErrorData({
    required dynamic data,
    required String message,
    required int statusCode,
  }) {
    final normalized = <String, dynamic>{};

    if (data is Map) {
      for (final entry in data.entries) {
        normalized[entry.key.toString()] = entry.value;
      }
    }

    normalized.putIfAbsent('code', () => 'FAILED');
    normalized['message'] = message;
    normalized.putIfAbsent('statusCode', () => statusCode);
    return normalized;
  }

  static String? _fromValue(dynamic value, {String? contentType}) {
    if (value == null) return null;

    if (value is Map) {
      for (final key in _messageKeys) {
        final matchingKey = value.keys.cast<dynamic>().where(
              (candidate) =>
                  candidate.toString().toLowerCase() == key.toLowerCase(),
            );
        if (matchingKey.isEmpty) continue;

        final message = _fromValue(value[matchingKey.first]);
        if (message != null) return message;
      }

      for (final key in const <String>['errors', 'response', 'data']) {
        if (!value.containsKey(key)) continue;
        final message = _fromValue(value[key]);
        if (message != null) return message;
      }
      return null;
    }

    if (value is Iterable) {
      for (final item in value) {
        final message = _fromValue(item);
        if (message != null) return message;
      }
      return null;
    }

    if (value is! String) return _cleanText(value.toString());

    final source = value.trim();
    if (source.isEmpty) return null;

    if (_looksLikeJson(source, contentType)) {
      try {
        return _fromValue(jsonDecode(source));
      } on FormatException {
        // Continue as HTML or plain text when a server labels invalid JSON.
      }
    }

    if (_looksLikeHtml(source, contentType)) {
      return _fromHtml(source);
    }

    return _cleanText(source);
  }

  static bool _looksLikeJson(String source, String? contentType) {
    final normalizedType = contentType?.toLowerCase() ?? '';
    return normalizedType.contains('json') ||
        source.startsWith('{') ||
        source.startsWith('[');
  }

  static bool _looksLikeHtml(String source, String? contentType) {
    final normalizedType = contentType?.toLowerCase() ?? '';
    final normalizedSource = source.toLowerCase();
    return normalizedType.contains('text/html') ||
        normalizedSource.startsWith('<!doctype html') ||
        normalizedSource.startsWith('<html');
  }

  static String? _fromHtml(String html) {
    final withoutNonVisibleContent = html
        .replaceAll(
          RegExp(r'<script\b[^>]*>[\s\S]*?</script\s*>', caseSensitive: false),
          ' ',
        )
        .replaceAll(
          RegExp(r'<style\b[^>]*>[\s\S]*?</style\s*>', caseSensitive: false),
          ' ',
        );

    // A visible heading generally describes an error more accurately than a
    // site's global <title>, so headings are intentionally checked first.
    for (final tag in const <String>['h1', 'h2', 'h3', 'title', 'p']) {
      final match = RegExp(
        '<$tag\\b[^>]*>([\\s\\S]*?)</$tag\\s*>',
        caseSensitive: false,
      ).firstMatch(withoutNonVisibleContent);
      final message = _cleanText(match?.group(1));
      if (message != null) return message;
    }

    return _cleanText(withoutNonVisibleContent);
  }

  static String? _cleanText(String? value) {
    if (value == null) return null;

    var text = value
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'&#(\d+);'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (text.isEmpty) return null;
    if (text.length > _maxMessageLength) {
      text = '${text.substring(0, _maxMessageLength - 1).trimRight()}…';
    }
    return text;
  }
}
