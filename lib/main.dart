import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/firebase/firebase_options.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/router/app_router.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_boilerplate/core/providers/theme_provider.dart';
import 'package:flutter_boilerplate/core/providers/locale_provider.dart';
import 'package:flutter_boilerplate/core/connectivity/connectivity_keys.dart';
import 'package:flutter_boilerplate/core/connectivity/connectivity_monitor.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/app_error_reporting_service.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';
import 'package:flutter_boilerplate/core/utils/firebase_messaging_service.dart';
import 'package:flutter_boilerplate/core/utils/foreground_alert_service.dart';
import 'package:flutter_boilerplate/features/chat/data/socket/socket_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
      defaultTargetPlatform == TargetPlatform.android &&
      Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await AppErrorReportingService.instance.initialize();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    unawaited(
      AppErrorReportingService.instance.recordFlutterFatalError(details),
    );
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    unawaited(
      AppErrorReportingService.instance.recordError(
        error,
        stackTrace,
        fatal: true,
        reason: 'Uncaught platform error',
      ),
    );
    return true;
  };

  runZonedGuarded(
    () {
      runApp(
        const ProviderScope(
          child: SafeArea(
            bottom: true,
            top: false,
            left: false,
            right: false,
            child: MyApp(),
          ),
        ),
      );
    },
    (error, stackTrace) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          error,
          stackTrace,
          fatal: true,
          reason: 'Uncaught zone error',
        ),
      );
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    DioClient().setLogoutHandler(() {
      ref.read(chatProvider).clearChatState();
      SocketService.instance.disconnect(reason: 'session expired logout');
      router.go(Paths.login);
    });

    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(localeNotifierProvider);

    return AppRealtimeBootstrap(
      child: ConnectivityMonitor(
        child: MaterialApp.router(
          title: 'Walima',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
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
        ),
      ),
    );
  }
}

class AppRealtimeBootstrap extends ConsumerStatefulWidget {
  const AppRealtimeBootstrap({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppRealtimeBootstrap> createState() =>
      _AppRealtimeBootstrapState();
}

class _AppRealtimeBootstrapState extends ConsumerState<AppRealtimeBootstrap>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ForegroundAlertService.instance.initialize();
      ForegroundAlertService.instance.setAppForeground(true);
      FirebaseMessagingService.instance.initialize(
        onNotificationSyncNeeded: () async {
          await ref.read(notiProvider).getNotificationCount();
        },
      );
      ref.read(globalProvider).initialize().then((_) async {
        final accessToken = await PrefsHelper.getAccessToken();
        if (accessToken.trim().isNotEmpty) {
          ref.read(globalProvider).refreshCurrentUserAndQuota(silent: true);
        }
      });
      ref.read(chatProvider).initializeRealtime();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ForegroundAlertService.instance
        .setAppForeground(state == AppLifecycleState.resumed);
    if (state == AppLifecycleState.resumed) {
      ref.read(chatProvider).initializeRealtime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
