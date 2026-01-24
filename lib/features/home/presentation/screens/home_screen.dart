import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/providers/theme_provider.dart';
import 'package:flutter_boilerplate/core/providers/locale_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.flutter_dash,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.welcome,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.appName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Theme Toggle Card
              Card(
                child: ListTile(
                  leading: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppColors.primary,
                  ),
                  title: Text(l10n.theme),
                  subtitle: Text(
                    themeMode == ThemeMode.dark
                        ? l10n.darkMode
                        : l10n.lightMode,
                  ),
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
                    },
                  ),
                ),
              ),

              // Language Toggle Card
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.language,
                    color: AppColors.primary,
                  ),
                  title: Text(l10n.language),
                  subtitle: Text(
                    locale.languageCode == 'en' ? l10n.english : l10n.bangla,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      ref.read(localeNotifierProvider.notifier).toggleLocale();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Features List
              Text(
                'Features',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildFeatureChip('Clean Architecture'),
              _buildFeatureChip('GoRouter Navigation'),
              _buildFeatureChip('Riverpod State Management'),
              _buildFeatureChip('Dio Network Layer'),
              _buildFeatureChip('Dark/Light Theme'),
              _buildFeatureChip('i18n Localization'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.helloWorld),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Chip(
        avatar: const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 20,
        ),
        label: Text(label),
        backgroundColor: AppColors.surfaceLight,
      ),
    );
  }
}
