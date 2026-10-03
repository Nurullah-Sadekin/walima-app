class SupportBotMessage {
  const SupportBotMessage({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  factory SupportBotMessage.fromJson(Map<String, dynamic> json) {
    return SupportBotMessage(
      id: (json['id'] ?? json['messageId'] ?? '').toString(),
      role: (json['role'] ?? json['sender'] ?? '').toString(),
      content: (json['content'] ?? json['text'] ?? json['finalText'] ?? '')
          .toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  final String id;
  final String role; // "user" | "assistant"
  final String content;
  final String? createdAt;
}
