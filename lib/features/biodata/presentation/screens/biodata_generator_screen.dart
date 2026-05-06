import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
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
      // appBar: AppBar(
      //   title: const Text('Download Biodata', style: TextStyle(color: AppColors.t)),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   surfaceTintColor: Colors.white,
      //   leading: IconButton(
      //     onPressed: () => context.pop(),
      //     icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //   ),
      // ),
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
          title: const Text('Download Bio-data'),
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
                    label: const Text('Save PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share'),
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
    final sections = biodata.sections
        .where((section) => section.items.isNotEmpty)
        .toList(growable: false);

    return Container(
      constraints: const BoxConstraints(minHeight: 540),
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
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
      child: Stack(
        children: [
          _TemplatePreviewBackground(template: template, accent: accent),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PreviewHeader(biodata: biodata, accent: accent),
                if (biodata.bio.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _PreviewParagraph(text: biodata.bio),
                ],
                const SizedBox(height: 18),
                ...sections.map(
                  (section) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _PreviewSection(section: section, accent: accent),
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Walima',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.25),
                      fontSize: TextSize.font18(context),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplatePreviewBackground extends StatelessWidget {
  const _TemplatePreviewBackground({
    required this.template,
    required this.accent,
  });

  final BiodataTemplate template;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              template.thumbnailPath,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.11),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.88)),
          ),
          Positioned(
            top: -40,
            right: -34,
            child: Container(
              width: 168,
              height: 118,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(64),
              ),
            ),
          ),
          Positioned(
            right: -18,
            top: 74,
            child: Container(
              width: 86,
              height: 118,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(64),
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: -28,
            child: Container(
              width: 170,
              height: 145,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(92),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({
    required this.biodata,
    required this.accent,
  });

  final BiodataDocument biodata;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                biodata.fullName.isEmpty ? 'Walima Biodata' : biodata.fullName,
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font24(context),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Marriage Biodata',
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 96,
          height: 118,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.76),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withValues(alpha: 0.14)),
          ),
          clipBehavior: Clip.antiAlias,
          child: biodata.profileImageUrl.startsWith('http')
              ? Image.network(
                  biodata.profileImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _PreviewImageFallback(
                    accent: accent,
                  ),
                )
              : _PreviewImageFallback(accent: accent),
        ),
      ],
    );
  }
}

class _PreviewImageFallback extends StatelessWidget {
  const _PreviewImageFallback({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.person_rounded,
      color: accent.withValues(alpha: 0.6),
      size: 42,
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
        Text(
          section.title,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font16(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
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
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 118,
            child: Text(
              item.label,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font12(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.value,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font13(context),
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
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
            ElevatedButton(onPressed: onRetry, child: const Text('Refresh')),
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
