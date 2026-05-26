class SupportBotConversation {
  const SupportBotConversation({
    required this.id,
    required this.status,
    this.language,
    this.createdAt,
    this.lastMessageAt,
  });

  factory SupportBotConversation.fromJson(Map<String, dynamic> json) {
    return SupportBotConversation(
      id: (json['id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      language: json['language']?.toString(),
      createdAt: json['createdAt']?.toString(),
      lastMessageAt: json['lastMessageAt']?.toString(),
    );
  }

  final String id;
  final String status;
  final String? language;
  final String? createdAt;
  final String? lastMessageAt;
}
