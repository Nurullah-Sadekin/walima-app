# Flutter Boilerplate Setup Guide

## Installation & Setup

### 1. Install Dependencies
```bash
cd /Users/nurullahsadekeen/Desktop/boilerplate
flutter pub get
```

### 2. Generate Code
Run build_runner to generate necessary files (*.g.dart files):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Centralized color constants
│   │   └── app_texts.dart           # Centralized text constants
│   ├── l10n/
│   │   ├── app_en.arb              # English translations
│   │   └── app_bn.arb              # Bangla translations
│   ├── network/
│   │   └── dio_client.dart         # Dio singleton with status code handling
│   ├── router/
│   │   └── app_router.dart         # GoRouter configuration
│   ├── theme/
│   │   └── app_theme.dart          # Light & Dark theme configuration
│   └── providers/
│       ├── theme_provider.dart     # Theme state management
│       └── locale_provider.dart    # Locale state management
├── features/
│   ├── home/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── user_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── user_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_user_usecase.dart
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart
│   └── settings/
│       └── presentation/
│           └── screens/
│               └── settings_screen.dart
└── main.dart
```

## Features Implemented

### ✅ Clean Architecture
- Features-first folder structure
- Separation of concerns: Data, Domain, Presentation layers
- Repository pattern for data access
- Use cases for business logic

### ✅ State Management (Riverpod)
- Theme state management with persistence
- Locale state management with persistence
- Provider-based architecture
- Code generation with riverpod_generator

### ✅ Routing (GoRouter)
- Declarative routing
- Type-safe navigation
- Error page handling
- Deep linking support ready

### ✅ Network Layer (Dio)
- Singleton pattern for Dio instance
- Status code handling (200, 201, 204, 400, 401, 402, 403, 404, 422, 429, etc.)
- Pretty logging with pretty_dio_logger
- Methods: GET, POST, PUT, PATCH, DELETE, Download
- Custom ApiResponse wrapper
- Error handling for timeouts, connection errors, etc.
- Token management (setAuthToken, removeAuthToken)

### ✅ Theming
- Material 3 design
- Light and Dark themes
- Customizable color scheme from AppColors
- Consistent component theming (buttons, cards, inputs, etc.)
- Theme persistence with SharedPreferences

### ✅ Localization
- English (en) and Bangla (bn) support
- ARB files for translations
- Easy to add more languages
- Locale persistence with SharedPreferences

### ✅ Centralized Constants
- **AppColors**: All color constants in one place
- **AppTexts**: Common text strings centralized

## Usage Examples

### Using Colors
```dart
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimaryLight),
  ),
)
```

### Using Texts
```dart
import 'package:flutter_boilerplate/core/constants/app_texts.dart';

Text(AppTexts.appName)
```

### Making API Calls
```dart
final dioClient = DioClient();

// GET request
final response = await dioClient.get('/users');
if (response.isSuccess) {
  print(response.data);
} else {
  print(response.message);
}

// POST request
final response = await dioClient.post(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
);

// PUT request
final response = await dioClient.put('/users/1', data: userData);

// DELETE request
final response = await dioClient.delete('/users/1');
```

### Toggling Theme
```dart
// Toggle between light and dark
ref.read(themeNotifierProvider.notifier).toggleTheme();

// Set specific theme
ref.read(themeNotifierProvider.notifier).setLightTheme();
ref.read(themeNotifierProvider.notifier).setDarkTheme();
ref.read(themeNotifierProvider.notifier).setSystemTheme();
```

### Changing Language
```dart
// Toggle between English and Bangla
ref.read(localeNotifierProvider.notifier).toggleLocale();

// Set specific language
ref.read(localeNotifierProvider.notifier).setEnglish();
ref.read(localeNotifierProvider.notifier).setBangla();
```

### Using Localized Strings
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcome)
Text(l10n.helloWorld)
```

### Navigation
```dart
// Push to a route
context.push('/settings');

// Go to a route (replace)
context.go('/home');

// Pop
context.pop();

// Push with named route
context.pushNamed('settings');
```

## Adding a New Feature

Follow clean architecture principles:

1. **Create feature folder**:
   ```
   features/
   └── your_feature/
       ├── data/
       │   ├── datasources/
       │   ├── models/
       │   └── repositories/
       ├── domain/
       │   ├── entities/
       │   ├── repositories/
       │   └── usecases/
       └── presentation/
           ├── providers/
           ├── screens/
           └── widgets/
   ```

2. **Create entity** (domain/entities/)
3. **Create repository interface** (domain/repositories/)
4. **Create use case** (domain/usecases/)
5. **Create model** (data/models/)
6. **Create datasource** (data/datasources/)
7. **Implement repository** (data/repositories/)
8. **Create UI** (presentation/)

## Configuration

### Update Base URL
Edit `lib/core/constants/app_texts.dart`:
```dart
static const String baseUrl = 'https://your-api.com';
```

### Add More Colors
Edit `lib/core/constants/app_colors.dart` and add your colors.

### Add More Languages
1. Create new ARB file (e.g., `app_es.arb` for Spanish)
2. Add locale to `supportedLocales` in `main.dart`
3. Update locale provider if needed

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Run app
flutter run

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Analyze code
flutter analyze

# Format code
flutter format .
```

## Notes

- Generated files (*.g.dart, *.freezed.dart) are git-ignored
- Run build_runner after creating new providers or models with annotations
- Theme and locale preferences are stored in SharedPreferences
- Dio client includes pretty logger for debugging API calls
- All status codes are handled in DioClient class

## Next Steps

1. Update the base URL in AppTexts
2. Add your app-specific features following the clean architecture structure
3. Customize colors and themes as needed
4. Add more translations to ARB files
5. Implement authentication if needed
6. Add environment configuration (.env files)
7. Set up CI/CD pipelines
8. Add unit tests and widget tests

Happy coding! 🚀
