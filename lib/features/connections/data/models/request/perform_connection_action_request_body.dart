class PerformConnectionActionRequestBody {
  PerformConnectionActionRequestBody({
    required this.action,
    required this.status,
    this.message,
    this.expiresAt,
    this.isPriority,
  });

  final String action;
  final String status;
  final String? message;
  final String? expiresAt;
  final bool? isPriority;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'action': action,
      'status': status,
      'message': message,
      'expiresAt': expiresAt,
      'isPriority': isPriority,
    };
  }
}
