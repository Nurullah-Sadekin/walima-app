import 'package:flutter_boilerplate/features/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_boilerplate/features/drawer/presentation/providers/app_drawer_provider.dart';
import 'package:flutter_boilerplate/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_boilerplate/features/login/presentation/providers/login_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/new_filter_provider.dart';
import 'package:flutter_boilerplate/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_screen_state_provider.dart';
import 'package:flutter_boilerplate/features/plans/presentation/providers/plans_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = ChangeNotifierProvider<LoginProvider>((ref) {
  return LoginProvider();
});

final registrationProvider =
    ChangeNotifierProvider<RegistrationProvider>((ref) {
  return RegistrationProvider();
});

final profileIsForScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final aboutYouScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final yourReligionScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final locationScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final emailPhoneScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final maritalStatusScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final qualificationScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final professionScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final aboutYourselfScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final verifyOtpForSignUp =
ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});


final verifyNumberScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final photoUploadScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final hobbiesInterestsScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final familyDetailsScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final familyFinancialStatusScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final profileCreatedStatusScreenProvider =
    ChangeNotifierProvider<RegistrationScreenStateProvider>((ref) {
  return RegistrationScreenStateProvider();
});

final recommendedPreferencesProvider =
    ChangeNotifierProvider<RecommendedPreferencesProvider>((ref) {
  return RecommendedPreferencesProvider();
});

final homeProvider = ChangeNotifierProvider<HomeProvider>((ref) {
  return HomeProvider();
});

final drawerProvider = ChangeNotifierProvider<DrawerProvider>((ref) {
  return DrawerProvider();
});
final plansProvider = ChangeNotifierProvider<PlansProvider>((ref) {
  return PlansProvider();
});
final matchesProvider = ChangeNotifierProvider<MatchesProvider>((ref) {
  return MatchesProvider();
});
final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  return ProfileProvider();
});

final searchFilterProvider = ChangeNotifierProvider<SearchFilterProvider>((ref) {
  return SearchFilterProvider();
});

final newFilterProvider = ChangeNotifierProvider<NewFilterProvider>((ref) {
  return NewFilterProvider();
});

final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) {
  return ChatProvider();
});
