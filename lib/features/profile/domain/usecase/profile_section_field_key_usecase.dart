class ProfileSectionFieldKeyUseCase {
  const ProfileSectionFieldKeyUseCase();

  String normalize(String? value) {
    return value?.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '') ??
        '';
  }

  String humanize(String value) {
    final spaced = value
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
        )
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .trim();
    if (spaced.isEmpty) {
      return value;
    }
    return spaced
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .map(
          (item) =>
              '${item[0].toUpperCase()}${item.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
