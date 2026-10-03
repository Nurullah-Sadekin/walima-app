class ProfileCompareResponse {
  ProfileCompareResponse({
    this.code,
    this.message,
    this.data,
    this.traceId,
  });

  factory ProfileCompareResponse.fromJson(dynamic json) {
    if (json is! Map) return ProfileCompareResponse();
    final map = Map<String, dynamic>.from(json);
    final response = map['response'];
    final responseData = response is Map ? response['data'] : null;
    return ProfileCompareResponse(
      code: map['code']?.toString(),
      message: map['message']?.toString(),
      data: responseData is Map
          ? ProfileCompareData.fromJson(Map<String, dynamic>.from(responseData))
          : null,
      traceId: map['traceId']?.toString(),
    );
  }

  final String? code;
  final String? message;
  final ProfileCompareData? data;
  final String? traceId;

  bool get isSuccess => code == 'SUCCESS' && data != null;
}

class ProfileCompareData {
  ProfileCompareData({
    this.matchPercentage,
    this.matchedCount,
    this.totalCriteria,
    this.verdict,
    this.compatibilityLevel,
    this.audit = const <CompareAuditItem>[],
  });

  factory ProfileCompareData.fromJson(Map<String, dynamic> json) {
    final auditRaw = json['audit'];
    final audit = (auditRaw is List)
        ? auditRaw
            .whereType<Map>()
            .map((e) => CompareAuditItem.fromJson(
                  Map<String, dynamic>.from(e),
                ))
            .toList(growable: false)
        : const <CompareAuditItem>[];
    return ProfileCompareData(
      matchPercentage: (json['matchPercentage'] as num?)?.toInt(),
      matchedCount: (json['matchedCount'] as num?)?.toInt(),
      totalCriteria: (json['totalCriteria'] as num?)?.toInt(),
      verdict: json['verdict']?.toString(),
      compatibilityLevel: json['compatibilityLevel']?.toString(),
      audit: audit,
    );
  }

  final int? matchPercentage;
  final int? matchedCount;
  final int? totalCriteria;
  final String? verdict;
  final String? compatibilityLevel;
  final List<CompareAuditItem> audit;
}

class CompareAuditItem {
  CompareAuditItem({
    this.field,
    this.status,
    this.preferredValue,
    this.actualValue,
    this.analysis,
  });

  factory CompareAuditItem.fromJson(Map<String, dynamic> json) =>
      CompareAuditItem(
        field: json['field']?.toString(),
        status: json['status']?.toString(),
        preferredValue: json['preferredValue']?.toString(),
        actualValue: json['actualValue']?.toString(),
        analysis: json['analysis']?.toString(),
      );

  final String? field;
  final String? status;
  final String? preferredValue;
  final String? actualValue;
  final String? analysis;

  bool get isMatched {
    final s = (status ?? '').toLowerCase();
    return s == 'match' || s == 'open';
  }
}
