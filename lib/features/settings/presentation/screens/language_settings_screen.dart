import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/providers/locale_provider.dart';
import 'package:walima_llc/generated/l10n/app_localizations.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.language,
          style: const TextStyle(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _LanguageOptionTile(
            title: l10n.english,
            subtitle: 'English',
            locale: const Locale('en'),
            currentLocale: currentLocale,
            onTap: () => ref.read(localeNotifierProvider.notifier).setEnglish(),
          ),
          const SizedBox(height: 12),
          _LanguageOptionTile(
            title: l10n.bangla,
            subtitle: 'বাংলা',
            locale: const Locale('bn'),
            currentLocale: currentLocale,
            onTap: () => ref.read(localeNotifierProvider.notifier).setBangla(),
          ),
        ],
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.currentLocale,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Locale locale;
  final Locale currentLocale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return Material(
      color: isSelected ? AppColors.primaryVariant : AppColors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.inputBorderColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        key: ValueKey('selected'),
                        color: AppColors.primary,
                      )
                    : const Icon(
                        Icons.circle_outlined,
                        key: ValueKey('unselected'),
                        color: AppColors.inputBorderColor,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
