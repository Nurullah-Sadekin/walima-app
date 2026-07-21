import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:walima_llc/generated/l10n/app_localizations.dart';
import 'package:walima_llc/core/firebase/firebase_options.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/router/app_router.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/theme/app_theme.dart';
import 'package:walima_llc/core/providers/theme_provider.dart';
import 'package:walima_llc/core/providers/locale_provider.dart';
import 'package:walima_llc/core/connectivity/connectivity_keys.dart';
import 'package:walima_llc/core/connectivity/connectivity_monitor.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/app_error_reporting_service.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';
import 'package:walima_llc/core/utils/firebase_messaging_service.dart';
import 'package:walima_llc/core/utils/foreground_alert_service.dart';
import 'package:walima_llc/features/chat/data/socket/socket_service.dart';
import 'core/config/app_flavor.dart';
import 'core/config/size_config.dart';

Future<void> main() async {
  AppConfig.initialize(); // Set the desired flavor here

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (!kIsWeb && Firebase.apps.isEmpty) {
        if (defaultTargetPlatform == TargetPlatform.android) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } else {
          await Firebase.initializeApp();
        }
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig().init(context);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    DioClient().setLogoutHandler(() {
      ref.read(chatProvider).clearChatState();
      ref.read(globalProvider).clearSessionState();
      SocketService.instance.disconnect(reason: 'session expired logout');
      router.go(Paths.onboarding);
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
            Locale('en'),
            Locale('bn'),
            Locale('ar'),
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
  ConsumerState<AppRealtimeBootstrap> createState() => _AppRealtimeBootstrapState();
}

class _AppRealtimeBootstrapState extends ConsumerState<AppRealtimeBootstrap> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ForegroundAlertService.instance.initialize();
      ForegroundAlertService.instance.setAppForeground(true);
      ref.read(globalProvider).initialize().then((_) async {
        final accessToken = await PrefsHelper.getAccessToken();
        if (accessToken.trim().isNotEmpty) {
          FirebaseMessagingService.instance.initialize(
            onNotificationSyncNeeded: () async {
              await ref.read(notiProvider).getNotificationCount();
            },
          );
          ref.read(globalProvider).refreshCurrentUserAndQuota(silent: true);
          ref.read(chatProvider).initializeRealtime(token: accessToken);
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ForegroundAlertService.instance.setAppForeground(state == AppLifecycleState.resumed);
    if (state == AppLifecycleState.resumed) {
      PrefsHelper.getAccessToken().then((accessToken) {
        if (accessToken.trim().isEmpty) return;
        ref.read(chatProvider).initializeRealtime(token: accessToken);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
