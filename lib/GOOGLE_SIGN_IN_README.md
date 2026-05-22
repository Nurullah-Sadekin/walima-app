# Google Sign-In (Krybon app implementation)

This document explains the full Google Sign-In implementation used in this app, and is written so you can copy the same approach into another Flutter project.

There are **two Google auth paths** in this codebase:

1) **Recommended / current mobile flow (Firebase Auth + `google_sign_in`)**  
   - User signs in with Google using native Google Sign-In.
   - App exchanges Google tokens for a **Firebase session** (`FirebaseAuth.signInWithCredential`).
   - App then sends the **Firebase ID token** to the backend (`/google-auth-via-firebase`) to create/login the app user.

2) **Legacy / alternate flow (Backend OAuth in WebView)**  
   - App opens a backend-provided Google OAuth URL inside a WebView.
   - Backend redirects to `/auth/google/callback?code=...`.
   - App extracts the `code` and calls backend callback API to finalize login.

If you’re starting a new Flutter project, implement **Flow #1** unless you specifically need WebView-based OAuth.

---

## Packages

In `pubspec.yaml` this project uses:

- `firebase_core`
- `firebase_auth`
- `google_sign_in`
- (plus other Firebase packages used by the app, e.g. Crashlytics/FCM)

---

## Flow #1 — Firebase Auth + Google Sign-In (native)

### Where the code lives

- Controller: `lib/features/auth/presentation/controllers/auth_controller.dart`
  - `startGoogleSignIn({bool isFromLogin = false})`
  - `submitGoogleReferral({String? referralCode})`
- Backend API call: `lib/features/auth/data/datasources/remote/google_auth_api.dart`
  - `googleAuthViaFirebase({ required String idToken, required String provider, String? referralCode })`

### What happens (sequence)

1) UI calls:
   - Login screen: `authController.startGoogleSignIn(isFromLogin: true)`
   - Signup screen: `authController.startGoogleSignIn()`

2) The controller starts Google Sign-In:
   - Creates `GoogleSignIn(scopes: ['email', 'profile'])`
   - Calls `googleSignIn.signIn()`

3) The controller signs into Firebase using Google credentials:
   - Builds credential via `GoogleAuthProvider.credential(idToken, accessToken)`
   - Calls `FirebaseAuth.instance.signInWithCredential(credential)`

4) The controller retrieves a **Firebase ID token**:
   - `userCred.user?.getIdToken()`
   - Stores it temporarily in `_googleIdToken`

5) The controller sends the **Firebase ID token** to backend:
   - `googleAuthViaFirebaseUseCase(idToken: firebaseIdToken, provider: 'google', referralCode: ...)`
   - On success, backend responds with the app’s access token (see `GoogleCallbackModel`)

6) The controller persists the backend token and navigates to the app:
   - `_persistAuth(...)` → `AppController.establishAuthenticatedSession(...)`
   - Navigates to the authenticated root (`RouteCoordinator.goToNavigation(...)`)

### Backend contract (important)

The backend endpoint used by this flow expects the token being sent to be a **Firebase ID token**, not the raw Google ID token. The app explicitly:

- Signs into Firebase with Google credentials, then
- Calls `getIdToken()` and sends that value as `idToken`.

Payload built in `GoogleAuthApi.googleAuthViaFirebase(...)`:

```json
{
  "idToken": "<FIREBASE_ID_TOKEN>",
  "provider": "google",
  "referralCode": "OPTIONAL"
}
```

### Firebase project setup (copy to new project)

1) Create / select a Firebase project in the Firebase Console.
2) Add your apps:
   - Android app: package name must match `android/app/build.gradle` → `applicationId`
   - iOS app: bundle identifier must match your Xcode target bundle id
3) Enable **Authentication → Sign-in method → Google** in Firebase Console.

### Android setup (copy to new project)

This repo already has the Google Services Gradle plugin enabled:

- `android/app/build.gradle` includes:
  - `id "com.google.gms.google-services"`

And the Firebase config is present at:

- `android/app/google-services.json`

For a new project:

1) Download `google-services.json` from Firebase Console and place it at:
   - `android/app/google-services.json`
2) Ensure the Gradle plugin is applied in `android/app/build.gradle`.
3) Add SHA fingerprints for Google Sign-In:
   - In Firebase Console → Project settings → Your Android app → add **SHA-1** (and SHA-256 if needed).
   - Use your **debug** keystore SHA-1 for local testing, and **release** keystore SHA-1 for production.

Helpful commands:

```bash
./gradlew signingReport
```

### iOS setup (copy to new project)

This repo initializes Firebase with `Firebase.initializeApp()` (no `firebase_options.dart`), which means iOS needs the native config file.

For a new project:

1) Download `GoogleService-Info.plist` from Firebase Console.
2) Add it to Xcode:
   - Put it in `ios/Runner/GoogleService-Info.plist`
   - Ensure it is included in the Runner target (Build Phases → Copy Bundle Resources).
3) Ensure Google Sign-In URL scheme is configured:
   - In Xcode, open `ios/Runner/Info.plist`
   - Add `CFBundleURLTypes` with the **reversed client id** from `GoogleService-Info.plist` (key: `REVERSED_CLIENT_ID`).

If the URL scheme is missing, iOS Google Sign-In typically fails to return to the app.

### Common failure checklist (Flow #1)

- `googleUser == null`: user cancelled the picker (not an error).
- `idToken == null`: Google sign-in misconfigured (often missing SHA-1 on Android, or URL scheme on iOS).
- Backend rejects token:
  - Make sure you are sending **Firebase ID token** (`user.getIdToken()`), not `googleAuth.idToken`.
- Wrong Firebase project / app ids:
  - `google-services.json` / `GoogleService-Info.plist` must match your package/bundle ids.

---

## Flow #2 — Backend OAuth URL + WebView (alternate)

### Where the code lives

- Screen: `lib/features/auth/presentation/google_auth_webview_screen.dart`
- Controller methods:
  - `getGoogleAuthUrl()` → calls backend to get an auth URL
  - `handleGoogleCallback(token: code)` → sends `code` to backend to finalize login

### What happens (sequence)

1) App asks backend for the Google OAuth URL via `getGoogleAuthUrl()`.
2) App loads the URL in a WebView (`GoogleAuthWebViewScreen`).
3) When WebView navigates to a URL containing `/auth/google/callback`:
   - Extracts `code` query parameter
   - Calls `handleGoogleCallback(token: code)`
4) On success, app persists the backend token and navigates to the authenticated root.

### When to use this flow

Use this if your backend must fully control Google OAuth (custom consent prompts, domain restrictions, or you want server-side token handling). Otherwise, Flow #1 is simpler and more “mobile-native”.

---

## How to reuse in another Flutter project (minimal copy plan)

1) Copy dependencies:
   - `firebase_core`, `firebase_auth`, `google_sign_in`
2) Initialize Firebase early (before any sign-in):
   - this project does it in `FirebaseSettings.fireBaseInit()` and calls `Firebase.initializeApp()`
3) Implement a `startGoogleSignIn()` method similar to:
   - `GoogleSignIn().signIn()`
   - `FirebaseAuth.instance.signInWithCredential(...)`
   - `user.getIdToken()`
4) Send the Firebase ID token to your backend to create/login the user.
5) Persist your backend session token and proceed to your authenticated app shell.

---

## Pointers into this codebase

- Main Google flow: `lib/features/auth/presentation/controllers/auth_controller.dart`
- Backend payload builder: `lib/features/auth/data/datasources/remote/google_auth_api.dart`
- WebView OAuth flow: `lib/features/auth/presentation/google_auth_webview_screen.dart`
- Firebase initialization: `lib/helpers/firebase_settings.dart`

