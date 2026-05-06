# Walima Flutter App

Flutter mobile application for the Walima platform. This repository contains the client app used for onboarding, profile management, matchmaking, chat, subscriptions, notifications, and related account workflows.

## Overview

Walima is a matchmaking platform app built with Flutter and organized with a feature-first structure. The project uses Riverpod for state management, GoRouter for navigation, Dio for API communication, Firebase for messaging and crash reporting, and Socket.IO for realtime chat behavior.

## Core Features

- User authentication with password and OTP flows
- Multi-step registration and profile onboarding
- Profile editing, preview, and account settings
- Match discovery, filters, and recommended preferences
- Realtime chat and inbox flows
- Notifications and unread count syncing
- Subscription plans and payment webview flow
- Bangla and English localization support
- Firebase messaging and Crashlytics integration

## Tech Stack

- Flutter
- Riverpod
- GoRouter
- Dio
- Socket.IO client
- Firebase Core
- Firebase Messaging
- Firebase Crashlytics
- WebView Flutter
- Freezed and JSON Serializable

## Project Structure

```text
lib/
├── core/                     # Shared app infrastructure
│   ├── connectivity/         # Connectivity monitoring and offline handling
│   ├── firebase/             # Firebase options and setup
│   ├── network/              # Dio client and API URLs
│   ├── providers/            # Global providers
│   ├── router/               # App routes and navigation config
│   ├── theme/                # App theme
│   └── utils/                # Shared helpers and services
├── features/
│   ├── login/                # Login, OTP, password flows
│   ├── registration/         # Onboarding and profile creation
│   ├── home/                 # Home and profile-related flows
│   ├── matches/              # Match list and filtering
│   ├── chat/                 # Realtime messaging
│   ├── inbox/                # Conversation and sent items
│   ├── notification/         # Notifications UI and state
│   ├── plans/                # Plans, purchase, payment webview
│   ├── profile/              # Profile screens and editing
│   ├── connections/          # Connection and relationship actions
│   ├── settings/             # App settings
│   └── ...
└── main.dart                 # Application bootstrap
```

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio or Xcode for device builds
- A configured Firebase setup for Android

### Installation

```bash
flutter pub get
```

### Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run the app

```bash
flutter run
```

## Configuration Notes

- The app currently points to the development API domain configured in [lib/core/network/app_urls.dart](/Volumes/development/freelance/walima/lib/core/network/app_urls.dart:1).
- Firebase initialization is handled in [lib/main.dart](/Volumes/development/freelance/walima/lib/main.dart:1) and platform configuration files.
- Push notification, crash reporting, connectivity monitoring, and realtime bootstrap logic are also initialized from `main.dart`.
- The package name still contains legacy `walima_llc` references in code imports and `pubspec.yaml`, even though the app branding is Walima.

## Useful Repository Docs

- [SETUP_GUIDE.md](/Volumes/development/freelance/walima/SETUP_GUIDE.md:1)
- [websocket_architecture.md](/Volumes/development/freelance/walima/websocket_architecture.md:1)
- [chat_socekt_documentation.md](/Volumes/development/freelance/walima/chat_socekt_documentation.md:1)
- [lookup_docs.md](/Volumes/development/freelance/walima/lookup_docs.md:1)
- [api_services/curl_runner_guide.md](/Volumes/development/freelance/walima/api_services/curl_runner_guide.md:1)

## Main Feature Areas

- `login`: sign in, OTP verification, password reset
- `registration`: about-you, religion, qualification, profession, family, financial status, photo upload
- `matches`: match browsing, filters, compatibility-related flows
- `chat` and `inbox`: realtime messaging and inbox management
- `plans`: subscriptions, upgrades, payment flow with WebView
- `notification`: notification list and sync handling
- `profile` and `account_setting`: profile maintenance and account controls

## Notes For Repository Setup

- Suitable for both internal development and client delivery workflows
- Recommended repository description:
  `Flutter mobile application for the Walima platform, structured for internal development, client collaboration, and deployment management.`
