enum AppFlavor { dev, prod }

class AppConfig {
  const AppConfig._(this.flavor);

  static const String _selectedFlavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );

  static AppConfig? _instance;

  final AppFlavor flavor;

  static AppConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('AppConfig.initialize() must be called before use.');
    }
    return config;
  }

  static void initialize() {
    _instance ??= fromFlavorName(_selectedFlavor);
  }

  static AppConfig fromFlavorName(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dev':
        return const AppConfig._(AppFlavor.dev);
      case 'prod':
        return const AppConfig._(AppFlavor.dev);
      default:
        throw ArgumentError.value(
          value,
          'APP_FLAVOR',
          'Unsupported flavor. Use "dev" or "dev".',
        );
    }
  }

  bool get isDev => flavor == AppFlavor.dev;
  bool get isProd => flavor == AppFlavor.prod;

  String get apiBaseUrl => switch (flavor) {
        AppFlavor.dev => 'https://dev.walima.app/api/v1',
        AppFlavor.prod => 'https://walima.app/api/v1',
      };

  String get imageBaseUrl => switch (flavor) {
        AppFlavor.dev => 'https://dev.walima.app/',
        AppFlavor.prod => 'https://walima.app/',
      };
}
