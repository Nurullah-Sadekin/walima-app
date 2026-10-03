import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/biodata/domain/model/biodata_document.dart';

class BioDataGeneratorScreen extends ConsumerStatefulWidget {
  const BioDataGeneratorScreen({super.key});

  @override
  ConsumerState<BioDataGeneratorScreen> createState() =>
      _BioDataGeneratorScreenState();
}

class _BioDataGeneratorScreenState
    extends ConsumerState<BioDataGeneratorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bioDataProvider).loadBiodata();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(bioDataProvider);
    final bioData = provider.biodata;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: Stack(
        children: [
          if (provider.isLoading)
            const Loading()
          else if (provider.errorMessage != null)
            _ErrorState(
              message: provider.errorMessage!,
              onRetry: ref.read(bioDataProvider).loadBiodata,
            )
          else if (bioData == null || !bioData.hasContent)
            _EmptyState(onRetry: ref.read(bioDataProvider).loadBiodata)
          else
            _Content(
              biodata: bioData,
              selectedTemplate: provider.selectedTemplate,
              onTemplateChanged: ref.read(bioDataProvider).selectTemplate,
              onRefresh: ref.read(bioDataProvider).loadBiodata,
              onSave: () => ref.read(bioDataProvider).savePdf(context),
              onShare: () => ref.read(bioDataProvider).sharePdf(context),
            ),
          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.35),
              child: const Loading(),
            ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.biodata,
    required this.selectedTemplate,
    required this.onTemplateChanged,
    required this.onRefresh,
    required this.onSave,
    required this.onShare,
  });

  final BiodataDocument biodata;
  final BiodataTemplate selectedTemplate;
  final ValueChanged<BiodataTemplate> onTemplateChanged;
  final Future<void> Function() onRefresh;
  final VoidCallback onSave;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBackAppBar(
          title: Text('Download Bio-data'.localized(context)),
          onBackPressed: () => context.pop(),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              children: [
                // _HeaderCard(biodata: biodata),
                // const SizedBox(height: 18),
                _TemplateSelector(
                  selectedTemplate: selectedTemplate,
                  onChanged: onTemplateChanged,
                ),
                const SizedBox(height: 18),
                _BiodataTemplatePreview(
                  biodata: biodata,
                  template: selectedTemplate,
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE6ECE9))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.download_rounded),
                    label: Text('Save PDF'.localized(context)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_rounded),
                    label: Text('Share'.localized(context)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TemplateSelector extends StatelessWidget {
  const _TemplateSelector({
    required this.selectedTemplate,
    required this.onChanged,
  });

  final BiodataTemplate selectedTemplate;
  final ValueChanged<BiodataTemplate> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Choose Template',
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${BiodataTemplate.values.length} designs',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font12(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: BiodataTemplate.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final template = BiodataTemplate.values[index];
                return _TemplateCard(
                  template: template,
                  isSelected: template == selectedTemplate,
                  onTap: () => onChanged(template),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  final BiodataTemplate template;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _templateColor(template);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 174,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF2B7A) : Colors.transparent,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.11),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        color: const Color(0xFFF5F6F7),
                        child: Image.asset(
                          template.thumbnailPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF2B7A),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Selected',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: TextSize.font13(context),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              template.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font16(context),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              template.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font12(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiodataTemplatePreview extends StatelessWidget {
  const _BiodataTemplatePreview({
    required this.biodata,
    required this.template,
  });

  final BiodataDocument biodata;
  final BiodataTemplate template;

  @override
  Widget build(BuildContext context) {
    final accent = _templateColor(template);
    final theme = _previewTheme(template, accent);
    final sections = biodata.sections
        .where((section) => section.items.isNotEmpty)
        .toList(growable: false);
    final headerOffset = template == BiodataTemplate.designTwo ? 190.0 : 42.0;
    final bodyOffset = template == BiodataTemplate.designTwo ? 285.0 : 250.0;
    final previewSections = _firstPageSections(sections);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 595 / 842,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 595,
            height: 842,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: theme.backgroundColor),
                ),
                ..._previewDecorations(template),
                Positioned(
                  left: 48,
                  top: headerOffset,
                  width: template == BiodataTemplate.designTwo ? 440 : 500,
                  child: _PreviewHeader(
                    biodata: biodata,
                    accent: theme.accentColor,
                    titleColor: theme.titleColor,
                    subtitleColor: theme.subtitleColor,
                    contactColor: theme.contactColor,
                  ),
                ),
                if (biodata.bio.isNotEmpty)
                  Positioned(
                    left: 48,
                    top: bodyOffset - 54,
                    width: 310,
                    child: _PreviewParagraph(text: biodata.bio),
                  ),
                Positioned(
                  left: 48,
                  top: bodyOffset,
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: previewSections.map((section) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _PreviewSection(
                          section: section,
                          accent: theme.accentColor,
                        ),
                      );
                    }).toList(growable: false),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/biodata/walima_logo_bio.svg',
                      width: 72,
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.28),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<BiodataSection> _firstPageSections(List<BiodataSection> sections) {
  const preferredTitles = <String>{
    'Personal Information',
    'Career & Financial',
    'Education',
    'Family Details',
  };
  final preferred = sections
      .where((section) => preferredTitles.contains(section.title))
      .map((section) {
    return BiodataSection(
      title: section.title == 'Education'
          ? 'Educational Background'
          : section.title,
      items: section.items
          .take(section.title == 'Personal Information' ? 6 : 4)
          .toList(),
    );
  }).toList(growable: false);

  if (preferred.isNotEmpty) return preferred;
  return sections.take(4).toList(growable: false);
}

class _PreviewTheme {
  const _PreviewTheme({
    required this.backgroundColor,
    required this.accentColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.contactColor,
  });

  final Color backgroundColor;
  final Color accentColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color contactColor;
}

_PreviewTheme _previewTheme(BiodataTemplate template, Color fallbackAccent) {
  switch (template) {
    case BiodataTemplate.mainBioData:
      return const _PreviewTheme(
        backgroundColor: Color(0xFFEFEFEF),
        accentColor: Color(0xFFFB3748),
        titleColor: Color(0xFF000000),
        subtitleColor: Color(0xFF171717),
        contactColor: Color(0xFF171717),
      );
    case BiodataTemplate.designOne:
      return const _PreviewTheme(
        backgroundColor: Color(0xFFF6F6F6),
        accentColor: Color(0xFFD1A590),
        titleColor: Color(0xFF000000),
        subtitleColor: Color(0xFF171717),
        contactColor: Color(0xFFD1A590),
      );
    case BiodataTemplate.designTwo:
      return const _PreviewTheme(
        backgroundColor: Color(0xFFF8E2E4),
        accentColor: Color(0xFFFB3748),
        titleColor: Color(0xFFFFFFFF),
        subtitleColor: Color(0xFFFFFFFF),
        contactColor: Color(0xFF171717),
      );
    default:
      return _PreviewTheme(
        backgroundColor: Colors.white,
        accentColor: fallbackAccent,
        titleColor: AppColors.textPrimaryLight,
        subtitleColor: AppColors.textPrimaryLight,
        contactColor: fallbackAccent,
      );
  }
}

List<Widget> _previewDecorations(BiodataTemplate template) {
  switch (template) {
    case BiodataTemplate.mainBioData:
      return const [
        _PreviewSvgDecoration(
          path: 'assets/biodata/flower_top.svg',
          top: 0,
          right: -4,
          width: 150,
          height: 108,
        ),
        _PreviewSvgDecoration(
          path: 'assets/biodata/flower_bottom.svg',
          left: -8,
          bottom: 0,
          width: 180,
          height: 170,
          opacity: 0.70,
        ),
      ];
    case BiodataTemplate.designOne:
      return const [
        _PreviewSvgDecoration(
          path: 'assets/biodata/designOne/designOneFlowerTop.svg',
          top: 0,
          right: -8,
          width: 184,
          height: 210,
        ),
        _PreviewSvgDecoration(
          path: 'assets/biodata/designOne/designOneFlowerBottom.svg',
          left: 0,
          bottom: 0,
          width: 240,
          height: 180,
        ),
      ];
    case BiodataTemplate.designTwo:
      return const [
        _PreviewSvgDecoration(
          path: 'assets/biodata/designTwo/designTop.svg',
          top: 0,
          left: 0,
          right: 0,
          height: 142,
        ),
        _PreviewSvgDecoration(
          path: 'assets/biodata/designTwo/designImage.svg',
          top: 28,
          left: 92,
          width: 34,
          height: 34,
        ),
        _PreviewSvgDecoration(
          path: 'assets/biodata/designTwo/designBottom.svg',
          left: 0,
          right: 0,
          bottom: 0,
          height: 74,
        ),
      ];
    case BiodataTemplate.designThree:
      return const [
        _PreviewPngDecoration(
          path: 'assets/biodata/designThree/designTop.png',
          top: 0,
          left: 0,
          right: 0,
          height: 142,
        ),
        _PreviewPngDecoration(
          path: 'assets/biodata/designThree/designBottom.png',
          left: 0,
          right: 0,
          bottom: 0,
          height: 115,
        ),
      ];
    case BiodataTemplate.designFour:
      return const [
        _PreviewPngDecoration(
          path: 'assets/biodata/designFour/designFourFlowerFull.png',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          opacity: 0.72,
        ),
      ];
    case BiodataTemplate.designFive:
      return const [
        _PreviewPngDecoration(
          path: 'assets/biodata/designFive/designFiveFlowerFull.png',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          opacity: 0.72,
        ),
      ];
    case BiodataTemplate.designSeven:
      return const [
        _PreviewPngDecoration(
          path: 'assets/biodata/designSeven/designSevenFullDesign.png',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          opacity: 0.76,
        ),
      ];
    case BiodataTemplate.designEight:
      return const [
        _PreviewPngDecoration(
          path: 'assets/biodata/designEight/designEightFullDesign.png',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          opacity: 0.76,
        ),
      ];
    case BiodataTemplate.designEleven:
      return const [
        _PreviewPngDecoration(
          path: 'assets/biodata/designEleven/designElevenFullDesign.png',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          opacity: 0.76,
        ),
      ];
    default:
      return [
        Positioned.fill(
          child: Image.asset(
            template.thumbnailPath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            opacity: const AlwaysStoppedAnimation(0.14),
          ),
        ),
      ];
  }
}

class _PreviewPngDecoration extends StatelessWidget {
  const _PreviewPngDecoration({
    required this.path,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.height,
    this.opacity = 1,
  });

  final String path;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      height: height,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(path, fit: BoxFit.fill),
      ),
    );
  }
}

class _PreviewSvgDecoration extends StatelessWidget {
  const _PreviewSvgDecoration({
    required this.path,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.opacity = 1,
  });

  final String path;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: Opacity(
        opacity: opacity,
        child: SvgPicture.asset(path, fit: BoxFit.fill),
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({
    required this.biodata,
    required this.accent,
    required this.titleColor,
    required this.subtitleColor,
    required this.contactColor,
  });

  final BiodataDocument biodata;
  final Color accent;
  final Color titleColor;
  final Color subtitleColor;
  final Color contactColor;

  @override
  Widget build(BuildContext context) {
    final profession = _findValue(biodata, 'Profession');
    final location = _findValue(biodata, 'Present Address');
    final email = _findValue(biodata, 'Email');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          biodata.fullName.isEmpty ? 'Walima Biodata' : biodata.fullName,
          style: TextStyle(
            color: titleColor,
            fontSize: TextSize.font28(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        if (profession.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            profession,
            style: TextStyle(
              color: subtitleColor,
              fontSize: TextSize.font16(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 18),
        if (location.isNotEmpty)
          _PreviewContactLine(
            icon: Icons.location_on_rounded,
            text: location,
            color: contactColor,
          ),
        if (email.isNotEmpty)
          _PreviewContactLine(
            icon: Icons.alternate_email_rounded,
            text: email,
            color: contactColor,
          ),
      ],
    );
  }
}

class _PreviewContactLine extends StatelessWidget {
  const _PreviewContactLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color.withValues(alpha: 0.74), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color.withValues(alpha: 0.86),
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewParagraph extends StatelessWidget {
  const _PreviewParagraph({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: TextSize.font13(context),
        height: 1.35,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.section,
    required this.accent,
  });

  final BiodataSection section;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Text(
              section.title,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...section.items.map(
          (item) => _PreviewInfoRow(item: item, accent: accent),
        ),
      ],
    );
  }
}

class _PreviewInfoRow extends StatelessWidget {
  const _PreviewInfoRow({
    required this.item,
    required this.accent,
  });

  final BiodataItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 126,
            child: Text(
              '${item.label}:',
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font12(context),
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.value,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font13(context),
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _findValue(BiodataDocument biodata, String label) {
  for (final section in biodata.sections) {
    for (final item in section.items) {
      if (item.label == label) return item.value;
    }
  }
  return '';
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.primary, size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Try again'.localized(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              'Complete your profile before generating biodata.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Refresh'.localized(context)),
            ),
          ],
        ),
      ),
    );
  }
}

Color _templateColor(BiodataTemplate template) {
  switch (template) {
    case BiodataTemplate.mainBioData:
    case BiodataTemplate.designSix:
      return const Color(0xFFC24F7A);
    case BiodataTemplate.designOne:
    case BiodataTemplate.designThree:
    case BiodataTemplate.designNine:
      return AppColors.primary;
    case BiodataTemplate.designFour:
    case BiodataTemplate.designEight:
      return const Color(0xFF2563A8);
    case BiodataTemplate.designTwo:
    case BiodataTemplate.designTen:
      return const Color(0xFFD79A24);
    case BiodataTemplate.designFive:
    case BiodataTemplate.designEleven:
      return const Color(0xFF8B5CF6);
    case BiodataTemplate.designSeven:
      return const Color(0xFFF97316);
  }
}
