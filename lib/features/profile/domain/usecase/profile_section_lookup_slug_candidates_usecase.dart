class ProfileSectionLookupSlugCandidatesUseCase {
  const ProfileSectionLookupSlugCandidatesUseCase();

  List<String> execute(String rawFieldKey) {
    final trimmed = rawFieldKey.trim();
    if (trimmed.isEmpty) {
      return const <String>[];
    }

    final kebab = trimmed
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)}-${match.group(2)}',
        )
        .replaceAll(RegExp(r'[_\s]+'), '-')
        .toLowerCase();
    final snake = kebab.replaceAll('-', '_');
    final compact = kebab.replaceAll('-', '');

    return <String>{
      trimmed,
      trimmed.toLowerCase(),
      kebab,
      snake,
      compact,
    }.toList(growable: false);
  }
}
