import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/generated/l10n/app_localizations.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/providers/theme_provider.dart';
import 'package:walima_llc/core/providers/locale_provider.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Theme Section
          _buildSectionHeader(context, l10n.theme),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l10n.lightMode),
                  subtitle: Text('Use light theme'.localized(context)),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeNotifierProvider.notifier)
                          .setThemeMode(value);
                    }
                  },
                  secondary: const Icon(Icons.light_mode),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.darkMode),
                  subtitle: Text('Use dark theme'.localized(context)),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeNotifierProvider.notifier)
                          .setThemeMode(value);
                    }
                  },
                  secondary: const Icon(Icons.dark_mode),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text('System'.localized(context)),
                  subtitle: Text('Use system theme'.localized(context)),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(themeNotifierProvider.notifier)
                          .setThemeMode(value);
                    }
                  },
                  secondary: const Icon(Icons.brightness_auto),
                ),
              ],
            ),
          ),

          // Language Section
          _buildSectionHeader(context, l10n.language),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                RadioListTile<Locale>(
                  title: Text(l10n.english),
                  subtitle: const Text('English'),
                  value: const Locale('en'),
                  groupValue: locale,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(localeNotifierProvider.notifier)
                          .setLocale(value);
                    }
                  },
                  secondary: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                ),
                const Divider(height: 1),
                RadioListTile<Locale>(
                  title: Text(l10n.bangla),
                  subtitle: const Text('বাংলা'),
                  value: const Locale('bn'),
                  groupValue: locale,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(localeNotifierProvider.notifier)
                          .setLocale(value);
                    }
                  },
                  secondary: const Text('🇧🇩', style: TextStyle(fontSize: 24)),
                ),
                const Divider(height: 1),
                RadioListTile<Locale>(
                  title: Text(l10n.arabic),
                  subtitle: const Text('العربية'),
                  value: const Locale('ar'),
                  groupValue: locale,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(localeNotifierProvider.notifier)
                          .setLocale(value);
                    }
                  },
                  secondary: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),

          // About Section
          _buildSectionHeader(context, l10n.about),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                  title: Text('Version'.localized(context)),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.code,
                    color: AppColors.primary,
                  ),
                  title: Text('Build Number'.localized(context)),
                  subtitle: const Text('1'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
