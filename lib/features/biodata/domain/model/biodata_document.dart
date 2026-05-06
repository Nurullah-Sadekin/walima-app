class BiodataDocument {
  const BiodataDocument({
    required this.fullName,
    required this.profileImageUrl,
    required this.bio,
    required this.sections,
  });

  final String fullName;
  final String profileImageUrl;
  final String bio;
  final List<BiodataSection> sections;

  bool get hasContent =>
      fullName.isNotEmpty ||
      bio.isNotEmpty ||
      sections.any((section) => section.items.isNotEmpty);
}

class BiodataSection {
  const BiodataSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<BiodataItem> items;
}

class BiodataItem {
  const BiodataItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

enum BiodataTemplate {
  mainBioData(
    id: 'mainBioData',
    label: 'Bio Data Main',
    title: 'Floral Romance',
    description: 'Elegant floral patterns and soft colors',
    thumbnailPath: 'assets/biodata/thumbnails/mainBioData_Thumbnail.png',
    totalPages: 2,
  ),
  designOne(
    id: 'designOne',
    label: 'Template One',
    title: 'Islamic Geometric',
    description: 'Beautiful Islamic art patterns',
    thumbnailPath: 'assets/biodata/thumbnails/designOne_Thumbnail.png',
    totalPages: 2,
  ),
  designTwo(
    id: 'designTwo',
    label: 'Template Two',
    title: 'Royal Heritage',
    description: 'Luxurious gold and royal accents',
    thumbnailPath: 'assets/biodata/thumbnails/designTwo_Thumbnail.png',
    totalPages: 3,
  ),
  designThree(
    id: 'designThree',
    label: 'Template Three',
    title: 'Garden Serenity',
    description: 'Fresh greens with natural elegance',
    thumbnailPath: 'assets/biodata/thumbnails/designThree_Thumbnail.png',
    totalPages: 3,
  ),
  designFour(
    id: 'designFour',
    label: 'Template Four',
    title: 'Sapphire Dream',
    description: 'Clear and modern blue elegance',
    thumbnailPath: 'assets/biodata/thumbnails/designFour_Thumbnail.png',
    totalPages: 1,
  ),
  designFive(
    id: 'designFive',
    label: 'Template Five',
    title: 'Midnight Charm',
    description: 'Elegant dark tones with soft accents',
    thumbnailPath: 'assets/biodata/thumbnails/designFive_Thumbnail.png',
    totalPages: 1,
  ),
  designSix(
    id: 'designSix',
    label: 'Template Six',
    title: 'Blossom Pink',
    description: 'Soft pink tones for a warm touch',
    thumbnailPath: 'assets/biodata/thumbnails/designSix_Thumbnail.png',
    totalPages: 1,
  ),
  designSeven(
    id: 'designSeven',
    label: 'Template Seven',
    title: 'Sunrise Glow',
    description: 'Warm orange hues with gentle sunrise',
    thumbnailPath: 'assets/biodata/thumbnails/designSeven_Thumbnail.png',
    totalPages: 1,
  ),
  designEight(
    id: 'designEight',
    label: 'Template Eight',
    title: 'Azure Breeze',
    description: 'Light cyan tones and gentle patterns',
    thumbnailPath: 'assets/biodata/thumbnails/designEight_Thumbnail.png',
    totalPages: 1,
  ),
  designNine(
    id: 'designNine',
    label: 'Template Nine',
    title: 'Emerald Grace',
    description: 'Rich green tones with classic style',
    thumbnailPath: 'assets/biodata/thumbnails/designNine_Thumbnail.png',
    totalPages: 1,
  ),
  designTen(
    id: 'designTen',
    label: 'Template Ten',
    title: 'Golden Harvest',
    description: 'Warm golden hues and earthy charm',
    thumbnailPath: 'assets/biodata/thumbnails/designTen_Thumbnail.png',
    totalPages: 1,
  ),
  designEleven(
    id: 'designEleven',
    label: 'Template Eleven',
    title: 'Lavender Grace',
    description: 'Soft lavender with refined elegance',
    thumbnailPath: 'assets/biodata/thumbnails/designEleven_Thumbnail.png',
    totalPages: 1,
  );

  const BiodataTemplate({
    required this.id,
    required this.label,
    required this.title,
    required this.description,
    required this.thumbnailPath,
    required this.totalPages,
  });

  final String id;
  final String label;
  final String title;
  final String description;
  final String thumbnailPath;
  final int totalPages;
}
