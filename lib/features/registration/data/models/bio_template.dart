class BioTemplate {
  BioTemplate({
    required this.id,
    required this.title,
    required this.content,
    List<String>? tags,
  }) : tags = tags ?? const <String>[];

  factory BioTemplate.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'];
    final parsedTags = rawTags is List
        ? rawTags.whereType<String>().toList(growable: false)
        : const <String>[];

    return BioTemplate(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      tags: parsedTags,
    );
  }

  final String id;
  final String title;
  final String content;
  final List<String> tags;
}

