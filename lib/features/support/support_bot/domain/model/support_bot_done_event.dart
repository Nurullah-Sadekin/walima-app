class SupportBotDoneEvent {
  const SupportBotDoneEvent({
    required this.conversationId,
    required this.messageId,
    required this.jobId,
    required this.finalText,
    required this.escalated,
    this.ticketId,
    this.needsConfirmation,
    this.blocked,
  });

  factory SupportBotDoneEvent.fromJson(Map<String, dynamic> json) {
    return SupportBotDoneEvent(
      conversationId: (json['conversationId'] ?? '').toString(),
      messageId: (json['messageId'] ?? '').toString(),
      jobId: (json['jobId'] ?? '').toString(),
      finalText: (json['finalText'] ?? '').toString(),
      escalated: json['escalated'] == true,
      ticketId: json['ticketId']?.toString(),
      needsConfirmation: json['needsConfirmation'],
      blocked: json['blocked'],
    );
  }

  final String conversationId;
  final String messageId;
  final String jobId;
  final String finalText;
  final bool escalated;
  final String? ticketId;
  final dynamic needsConfirmation;
  final dynamic blocked;
}
