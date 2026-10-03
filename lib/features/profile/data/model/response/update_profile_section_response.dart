class UpdateProfileSectionResponse {
  UpdateProfileSectionResponse({
    this.code,
    this.message,
    this.response,
    this.traceId,
  });

  factory UpdateProfileSectionResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileSectionResponse(
      code: json['code']?.toString(),
      message: json['message']?.toString(),
      response: json['response'],
      traceId: json['traceId']?.toString(),
    );
  }

  final String? code;
  final String? message;
  final dynamic response;
  final String? traceId;

  bool get isSuccess => (code ?? '').toUpperCase() == 'SUCCESS';
}
