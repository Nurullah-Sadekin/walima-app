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
                if (biodata.bio.isNotEmpty)
                  _BioCard(
                    bio: biodata.bio,
                    template: selectedTemplate,
                  ),
                if (biodata.bio.isNotEmpty) const SizedBox(height: 14),
                ...biodata.sections.map(
                  (section) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _SectionCard(section: section),
                  ),
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.biodata});

  final BiodataDocument biodata;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: biodata.profileImageUrl.startsWith('http')
                ? NetworkImage(biodata.profileImageUrl)
                : null,
            child: biodata.profileImageUrl.startsWith('http')
                ? null
                : Text(
                    _initials(biodata.fullName),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: TextSize.font20(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  biodata.fullName.isEmpty
                      ? 'Walima Biodata'
                      : biodata.fullName,
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font20(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Marriage Biodata',
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font13(context),
                    fontWeight: FontWeight.w500,
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

class _BioCard extends StatelessWidget {
  const _BioCard({
    required this.bio,
    required this.template,
  });

  final String bio;
  final BiodataTemplate template;

  @override
  Widget build(BuildContext context) {
    final accent = _templateColor(template);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              template.thumbnailPath,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                ),
              ),
              child: Text(
                template.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: accent,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _SectionTitle(title: 'About'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  bio,
                  style: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: TextSize.font14(context),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final BiodataSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: section.title),
          const SizedBox(height: 10),
          ...section.items.map((item) => _InfoRow(item: item)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: TextSize.font16(context),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final BiodataItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              item.label,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font13(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.value,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font14(context),
                height: 1.25,
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

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFE6ECE9)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.035),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
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

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return 'W';
  return parts.take(2).map((part) => part[0].toUpperCase()).join();
}
