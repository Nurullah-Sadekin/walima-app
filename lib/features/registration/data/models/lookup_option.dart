class LookupOption {
  const LookupOption({
    required this.key,
    required this.label,
  });

  factory LookupOption.fromJson(Map<String, dynamic> json) {
    return LookupOption(
      key: (json['key'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
    );
  }

  final String key;
  final String label;
}
