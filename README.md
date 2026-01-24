# Flutter Boilerplate

A comprehensive Flutter boilerplate with clean architecture and modern best practices.

## Features

- ✅ **Clean Architecture** with features-first folder structure
- ✅ **State Management** with Riverpod
- ✅ **Navigation** with GoRouter
- ✅ **Network Layer** with Dio and pretty_dio_logger
- ✅ **Localization** for English and Bangla
- ✅ **Theme Management** with Dark/Light mode support
- ✅ **Centralized Colors** and Text constants
- ✅ **Type-safe API calls** with status code handling

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_texts.dart
│   ├── l10n/
│   │   ├── app_en.arb
│   │   └── app_bn.arb
│   ├── network/
│   │   └── dio_client.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── providers/
│       └── theme_provider.dart
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           └── widgets/
└── main.dart
```

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

### Network Calls

```dart
final dioClient = DioClient();
final response = await dioClient.get('/endpoint');
```

### Theme Toggle

```dart
ref.read(themeProvider.notifier).toggleTheme();
```

### Navigation

```dart
context.go('/route-name');
```

### Localization

```dart
AppLocalizations.of(context)!.helloWorld
```
