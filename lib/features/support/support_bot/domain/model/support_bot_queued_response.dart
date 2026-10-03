class SupportBotQueuedResponse {
  const SupportBotQueuedResponse({
    required this.queued,
    required this.jobId,
    required this.messageId,
    required this.escalated,
    this.ticketId,
    this.finalText,
    this.needsConfirmation,
    this.blocked,
  });

  factory SupportBotQueuedResponse.fromJson(Map<String, dynamic> json) {
    return SupportBotQueuedResponse(
      queued: json['queued'] == true,
      jobId: (json['jobId'] ?? '').toString(),
      messageId: (json['messageId'] ?? '').toString(),
      escalated: json['escalated'] == true,
      ticketId: json['ticketId']?.toString(),
      finalText: json['finalText']?.toString(),
      needsConfirmation: json['needsConfirmation'],
      blocked: json['blocked'],
    );
  }

  final bool queued;
  final String jobId;
  final String messageId;
  final bool escalated;
  final String? ticketId;
  final String? finalText;
  final dynamic needsConfirmation;
  final dynamic blocked;
}
