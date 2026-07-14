class ContactSupportResponse {
  const ContactSupportResponse({
    required this.code,
    required this.message,
  });

  factory ContactSupportResponse.fromJson(Map<String, dynamic> json) {
    return ContactSupportResponse(
      code: (json['code'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
    );
  }

  final String code;
  final String message;
}
