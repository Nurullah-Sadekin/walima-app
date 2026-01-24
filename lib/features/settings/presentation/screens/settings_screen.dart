import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/providers/theme_provider.dart';
import 'package:flutter_boilerplate/core/providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
                  subtitle: const Text('Use light theme'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeNotifierProvider.notifier).setThemeMode(value);
                    }
                  },
                  secondary: const Icon(Icons.light_mode),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: Text(l10n.darkMode),
                  subtitle: const Text('Use dark theme'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeNotifierProvider.notifier).setThemeMode(value);
                    }
                  },
                  secondary: const Icon(Icons.dark_mode),
                ),
                const Divider(height: 1),
                RadioListTile<ThemeMode>(
                  title: const Text('System'),
                  subtitle: const Text('Use system theme'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeNotifierProvider.notifier).setThemeMode(value);
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
                      ref.read(localeNotifierProvider.notifier).setLocale(value);
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
                      ref.read(localeNotifierProvider.notifier).setLocale(value);
                    }
                  },
                  secondary: const Text('🇧🇩', style: TextStyle(fontSize: 24)),
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
                  leading: Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.code,
                    color: AppColors.primary,
                  ),
                  title: const Text('Build Number'),
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
