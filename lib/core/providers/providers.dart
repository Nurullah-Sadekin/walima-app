import 'package:walima_llc/core/global/providers/global_provider.dart';
import 'package:walima_llc/features/biodata/presentation/provider/biodata_provider.dart';
import 'package:walima_llc/features/chat/presentation/provider/chat_provider.dart';
import 'package:walima_llc/features/drawer/presentation/providers/app_drawer_provider.dart';
import 'package:walima_llc/features/home/presentation/providers/home_provider.dart';
import 'package:walima_llc/features/inbox/presentation/providers/inbox_providers.dart';
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';
import 'package:walima_llc/features/matches/presentation/provider/matcher_provider.dart';
import 'package:walima_llc/features/matches/presentation/provider/search_filter_provider.dart';
import 'package:walima_llc/features/matches/presentation/provider/new_filter_provider.dart';
import 'package:walima_llc/features/matches/presentation/provider/my_match_filter_provider.dart';
import 'package:walima_llc/features/notification/presentation/providers/notificaiton_provider.dart';
import 'package:walima_llc/features/profile/presentation/providers/profile_provider.dart';
import 'package:walima_llc/features/profile_preview/presentation/providers/profile_preview_provider.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_screen_state_provider.dart';
import 'package:walima_llc/features/plans/presentation/providers/plans_provider.dart';
import 'package:walima_llc/features/account_setting/presentation/providers/account_setting_provider.dart';
import 'package:walima_llc/features/identity_verification/presentation/providers/identity_verification_provider.dart';
import 'package:walima_llc/features/contact_filter/presentation/providers/contact_filter_provider.dart';
import 'package:walima_llc/features/support/presentation/provider/support_provider.dart';
import 'package:walima_llc/features/support/presentation/provider/ai_support_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = ChangeNotifierProvider<LoginProvider>((ref) {
  return LoginProvider();
});

final registrationProvider =
    ChangeNotifierProvider<RegistrationProvider>((ref) {
  return RegistrationProvider();
});

final registrationScreenStateProvider =
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
final inboxProvider = ChangeNotifierProvider<InboxProvider>((ref) {
  return InboxProvider();
});
final matchesProvider = ChangeNotifierProvider<MatchesProvider>((ref) {
  return MatchesProvider();
});
final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  return ProfileProvider();
});

final bioDataProvider = ChangeNotifierProvider<BioDataProvider>((ref) {
  return BioDataProvider();
});

final profilePreviewProvider =
    ChangeNotifierProvider<ProfilePreviewProvider>((ref) {
  return ProfilePreviewProvider();
});

final searchFilterProvider =
    ChangeNotifierProvider<SearchFilterProvider>((ref) {
  return SearchFilterProvider();
});

final newFilterProvider = ChangeNotifierProvider<NewFilterProvider>((ref) {
  return NewFilterProvider();
});

final myMatchFilterProvider =
    ChangeNotifierProvider<MyMatchFilterProvider>((ref) {
  return MyMatchFilterProvider();
});

final accountSettingProvider =
    ChangeNotifierProvider<AccountSettingProvider>((ref) {
  return AccountSettingProvider();
});

final identityVerificationProvider =
    ChangeNotifierProvider<IdentityVerificationProvider>((ref) {
  return IdentityVerificationProvider();
});

final contactFilterProvider =
    ChangeNotifierProvider<ContactFilterProvider>((ref) {
  return ContactFilterProvider();
});

final supportProvider = ChangeNotifierProvider<SupportProvider>((ref) {
  return SupportProvider();
});

final aiSupportProvider = ChangeNotifierProvider<AiSupportProvider>((ref) {
  return AiSupportProvider();
});

final chatProvider = ChangeNotifierProvider<ChatProvider>((ref) {
  return ChatProvider(ref);
});

final globalProvider = ChangeNotifierProvider<GlobalProvider>((ref) {
  return GlobalProvider();
});
final notiProvider = ChangeNotifierProvider<NotificationProvider>((ref) {
  return NotificationProvider();
});
