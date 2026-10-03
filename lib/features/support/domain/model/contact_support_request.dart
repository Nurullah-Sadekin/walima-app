class ContactSupportRequest {
  const ContactSupportRequest({
    required this.subject,
    required this.message,
    this.email,
    this.phone,
  });

  final String subject;
  final String message;
  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'message': message,
      if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
    };
  }
}
