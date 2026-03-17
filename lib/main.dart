import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/router/app_router.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_boilerplate/core/providers/theme_provider.dart';
import 'package:flutter_boilerplate/core/providers/locale_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SafeArea(
          bottom: true, top: false, left: false, right: false, child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    DioClient().setLogoutHandler(() {
      router.go(Paths.login);
    });

    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'Walima',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: themeMode,

      // Routing
      routerConfig: router,

      // Localization
      locale: locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('bn'), // Bangla
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
