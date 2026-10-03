class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.code,
    required this.message,
    required this.response,
    required this.traceId,
  });

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) decode,
  ) {
    final rawResponse = json['response'];
    if (rawResponse is! Map) {
      throw const FormatException('API envelope is missing response payload.');
    }

    return ApiEnvelope<T>(
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      response: decode(Map<String, dynamic>.from(rawResponse)),
      traceId: json['traceId']?.toString() ?? '',
    );
  }

  final String code;
  final String message;
  final T response;
  final String traceId;

  bool get isSuccess => code.toUpperCase() == 'SUCCESS';
}
