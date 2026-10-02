import 'package:flutter/material.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/biodata/presentation/screens/biodata_generator_screen.dart';
import 'package:walima_llc/features/login/presentation/login_with_email_screen.dart';
import 'package:walima_llc/features/login/presentation/login_with_phone_screen.dart';
import 'package:walima_llc/features/matches/presentation/screens/filters/new_filter.dart';
import 'package:walima_llc/features/contact_filter/presentation/screens/contact_filter_screen.dart';
import 'package:walima_llc/features/account_setting/presentation/screens/account_setting_screen.dart';
import 'package:walima_llc/features/account_setting/presentation/screens/phone_verification_screen.dart';
import 'package:walima_llc/features/profile/presentation/screen/edit_profile.dart';
import 'package:walima_llc/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:walima_llc/features/profile/presentation/screen/profile_section_edit_screen.dart';
import 'package:walima_llc/features/profile/presentation/screen/contact_information_screen.dart';
import 'package:walima_llc/features/login/presentation/screens/new_password.dart';
import 'package:walima_llc/features/login/presentation/screens/otp_verify.dart';
import 'package:walima_llc/features/login/presentation/screens/reset_pssword_status.dart';
import 'package:walima_llc/features/login/presentation/screens/send_otp.dart';
import 'package:walima_llc/features/matches/presentation/screens/matches.dart';
import 'package:walima_llc/features/matches/presentation/screens/filters/search_filter.dart';
import 'package:walima_llc/features/matches/presentation/screens/filters/my_match_filter.dart';
import 'package:walima_llc/features/notification/presentation/notification_screen.dart';
import 'package:walima_llc/features/onboarding_screen.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/connect_matches.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/basic_details.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/career.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/community.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/education.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/other_details.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/partner_preferences.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/recommended_preferences/preference_location.dart';
import 'package:walima_llc/features/registration/presentation/screens/crop_image.dart';
import 'package:walima_llc/features/plans/presentation/screens/plans_screen.dart';
import 'package:walima_llc/features/plans/presentation/screens/payment_webview_screen.dart';
import 'package:walima_llc/features/home/presentation/screens/home_view_all_screen.dart';
import 'package:walima_llc/features/home/presentation/screens/government_id_verify_screen.dart';
import 'package:walima_llc/features/identity_verification/presentation/screens/identity_verification_screen.dart';
import 'package:walima_llc/features/identity_verification/presentation/screens/didit_verification_webview_screen.dart';
import 'package:walima_llc/features/registration/presentation/screens/about_you.dart';
import 'package:walima_llc/features/registration/presentation/screens/email_phone.dart';
import 'package:walima_llc/features/registration/presentation/screens/family_details.dart';
import 'package:walima_llc/features/registration/presentation/screens/family_financial_status.dart';
import 'package:walima_llc/features/registration/presentation/screens/hobbies_interests.dart';
import 'package:walima_llc/features/registration/presentation/screens/marriage_intention.dart';
import 'package:walima_llc/features/registration/presentation/screens/religious_practice.dart';
import 'package:walima_llc/features/registration/presentation/screens/photo_upload.dart';
import 'package:walima_llc/features/registration/presentation/screens/profile_created_status.dart';
import 'package:walima_llc/features/registration/presentation/screens/profile_is_for.dart';
import 'package:walima_llc/features/registration/presentation/screens/verify_number.dart';
import 'package:walima_llc/features/registration/presentation/screens/verify_otp_for_sign_up.dart';
import 'package:walima_llc/features/registration/presentation/screens/location_and_your_religion.dart';
import 'package:walima_llc/features/settings/presentation/screens/language_settings_screen.dart';
import 'package:walima_llc/features/settings/presentation/screens/settings_screen.dart';
import 'package:walima_llc/features/support/presentation/screens/contact_support_screen.dart';
import 'package:walima_llc/features/support/presentation/screens/help_desk_screen.dart';
import 'package:walima_llc/features/support/presentation/screens/ai_support_chat_screen.dart';
import 'package:walima_llc/core/connectivity/connectivity_keys.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:walima_llc/features/splash_screen.dart';
import 'package:walima_llc/features/anchor_point/anchor_point.dart';
import 'package:walima_llc/features/login/presentation/login_screen.dart';
import 'package:walima_llc/features/registration/presentation/screens/location.dart';
import 'package:walima_llc/features/registration/presentation/screens/marital_status.dart';
import 'package:walima_llc/features/registration/presentation/screens/qualification.dart';
import 'package:walima_llc/features/registration/presentation/screens/profession.dart';
import 'package:walima_llc/features/registration/presentation/screens/about_yourself.dart';
import '../../features/chat/presentation/screens/one_to_one_chat_screen.dart';
import '../../features/profile_preview/presentation/screens/profile_preview_screen.dart';
import 'route_name.dart';
import 'package:walima_llc/features/chat/presentation/screens/report_screen.dart';
import 'package:walima_llc/features/chat/presentation/screens/status_screen.dart';
part 'app_router.g.dart';

const _publicPaths = {
  Paths.splash,
  Paths.onboarding,
  Paths.login,
  Paths.loginWithEmail,
  Paths.loginWithPhone,
  Paths.sendOtp,
  Paths.otpVerify,
  Paths.newPassword,
  Paths.resetPasswordStatus,
  // Registration flow
  Paths.isProfileFor,
  Paths.aboutYou,
  Paths.yourReligion,
  Paths.religiousPractice,
  Paths.marriageIntention,
  Paths.emailPhone,
  Paths.location,
  Paths.maritalStatus,
  Paths.qualification,
  Paths.profession,
  Paths.aboutYourself,
  Paths.verifyNumber,
  Paths.otpVerifyForSignUp,
  Paths.photoUpload,
  Paths.hobbiesInterests,
  Paths.familyDetails,
  Paths.financialStatus,
  Paths.profileCreatedStatus,
  Paths.cropImage,
};

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Paths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      if (_publicPaths.contains(state.matchedLocation)) return null;
      final token = await PrefsHelper.getAccessToken();
      if (token.trim().isEmpty) return Paths.onboarding;
      return null;
    },
    routes: [
      GoRoute(
        path: Paths.splash,
        name: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Paths.anchor,
        name: Routes.anchor,
        builder: (context, state) => const AnchorPointScreen(),
      ),
      GoRoute(
        path: Paths.login,
        name: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Paths.loginWithEmail,
        name: Routes.loginWithEmail,
        builder: (context, state) => const LoginWithEmailScreen(),
      ),
      GoRoute(
        path: Paths.loginWithPhone,
        name: Routes.loginWithPhone,
        builder: (context, state) => const LoginWithPhoneScreen(),
      ),
      GoRoute(
        path: Paths.sendOtp,
        name: Routes.sendOtp,
        builder: (context, state) => const SendOtpScreen(),
      ),
      GoRoute(
        path: Paths.otpVerify,
        name: Routes.otpVerify,
        builder: (context, state) => const OtpVerifyScreen(),
      ),
      GoRoute(
        path: Paths.otpVerifyForSignUp,
        name: Routes.otpVerifyForSignUp,
        builder: (context, state) {
          final fromScreenFromQuery =
              state.uri.queryParameters['fromScreen']?.trim();
          final fromScreenFromExtra =
              state.extra is String ? (state.extra as String).trim() : null;
          final fromScreen = fromScreenFromQuery?.isNotEmpty == true
              ? fromScreenFromQuery
              : fromScreenFromExtra;
          return OtpVerifySignUpScreen(fromScreen: fromScreen);
        },
      ),
      GoRoute(
        path: Paths.newPassword,
        name: Routes.newPassword,
        builder: (context, state) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: Paths.resetPasswordStatus,
        name: Routes.resetPasswordStatus,
        builder: (context, state) => const ResetPasswordStatusScreen(),
      ),
      GoRoute(
        path: Paths.settings,
        name: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Paths.languageSettings,
        name: Routes.languageSettings,
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: Paths.notifications,
        name: Routes.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: Paths.contactSupport,
        name: Routes.contactSupport,
        builder: (context, state) => const ContactSupportScreen(),
      ),
      GoRoute(
        path: Paths.helpDesk,
        name: Routes.helpDesk,
        builder: (context, state) => const HelpDeskScreen(),
      ),
      GoRoute(
        path: Paths.aiSupport,
        name: Routes.aiSupport,
        builder: (context, state) => const AiSupportChatScreen(),
      ),
      GoRoute(
        path: Paths.onboarding,
        name: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Paths.isProfileFor,
        name: Routes.isProfileFor,
        builder: (context, state) => const IsProfileForScreen(),
      ),
      GoRoute(
        path: Paths.aboutYou,
        name: Routes.aboutYou,
        builder: (context, state) => const AboutYouScreen(),
      ),
      GoRoute(
        path: Paths.yourReligion,
        name: Routes.yourReligion,
        builder: (context, state) => const LocationAndYourReligion(),
      ),
      GoRoute(
        path: Paths.religiousPractice,
        name: Routes.religiousPractice,
        builder: (context, state) => const ReligiousPracticeScreen(),
      ),
      GoRoute(
        path: Paths.marriageIntention,
        name: Routes.marriageIntention,
        builder: (context, state) => const MarriageIntentionScreen(),
      ),
      GoRoute(
        path: Paths.emailPhone,
        name: Routes.emailPhone,
        builder: (context, state) {
          final fromScreenFromQuery =
              state.uri.queryParameters['fromScreen']?.trim();
          final fromScreenFromExtra =
              state.extra is String ? (state.extra as String).trim() : null;
          final fromScreen = fromScreenFromQuery?.isNotEmpty == true
              ? fromScreenFromQuery
              : fromScreenFromExtra;
          return EmailPhoneScreen(fromScreen: fromScreen);
        },
      ),
      GoRoute(
        path: Paths.location,
        name: Routes.location,
        builder: (context, state) => const LocationScreen(),
      ),
      GoRoute(
        path: Paths.maritalStatus,
        name: Routes.maritalStatus,
        builder: (context, state) => const MaritalStatusScreen(),
      ),
      GoRoute(
        path: Paths.qualification,
        name: Routes.qualification,
        builder: (context, state) => const QualificationScreen(),
      ),
      GoRoute(
        path: Paths.profession,
        name: Routes.profession,
        builder: (context, state) => const ProfessionScreen(),
      ),
      GoRoute(
        path: Paths.aboutYourself,
        name: Routes.aboutYourself,
        builder: (context, state) => const AboutYourselfScreen(),
      ),
      GoRoute(
        path: Paths.verifyNumber,
        name: Routes.verifyNumber,
        builder: (context, state) {
          final extra = state.extra;
          String? fromScreen;

          if (extra is String) {
            fromScreen = extra.trim();
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            final rawFromScreen = map['fromScreen'];
            if (rawFromScreen is String) {
              fromScreen = rawFromScreen.trim();
            }
          }

          return VerifyNumberScreen(fromScreen: fromScreen);
        },
      ),
      GoRoute(
        path: Paths.photoUpload,
        name: Routes.photoUpload,
        builder: (context, state) {
          final extra = state.extra;
          String? fromScreen;

          if (extra is String) {
            fromScreen = extra.trim();
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            final rawFromScreen = map['fromScreen'];
            if (rawFromScreen is String) {
              fromScreen = rawFromScreen.trim();
            }
          }

          return PhotoUploadScreen(fromScreen: fromScreen);
        },
      ),
      GoRoute(
        path: Paths.hobbiesInterests,
        name: Routes.hobbiesInterests,
        builder: (context, state) => const HobbiesInterestsScreen(),
      ),
      GoRoute(
        path: Paths.familyDetails,
        name: Routes.familyDetails,
        builder: (context, state) => const FamilyDetailsScreen(),
      ),
      GoRoute(
        path: Paths.financialStatus,
        name: Routes.financialStatus,
        builder: (context, state) => const FamilyFinancialStatusScreen(),
      ),
      GoRoute(
        path: Paths.profileCreatedStatus,
        name: Routes.profileCreatedStatus,
        builder: (context, state) => const ProfileCreateStatusScreen(),
      ),
      GoRoute(
        path: Paths.partnerPreferences,
        name: Routes.partnerPreferences,
        builder: (context, state) {
          final extra = state.extra;
          final isFromDrawer =
              extra is Map<String, dynamic> && extra['fromDrawer'] == true;
          return PartnerPreferencesScreen(isFromDrawer: isFromDrawer);
        },
      ),
      GoRoute(
        path: Paths.basicDetails,
        name: Routes.basicDetails,
        builder: (context, state) => const BasicDetailsScreen(),
      ),
      GoRoute(
        path: Paths.community,
        name: Routes.community,
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: Paths.preferenceLocation,
        name: Routes.preferenceLocation,
        builder: (context, state) => const PreferenceLocationScreen(),
      ),
      GoRoute(
        path: Paths.education,
        name: Routes.education,
        builder: (context, state) => const EducationScreen(),
      ),
      GoRoute(
        path: Paths.career,
        name: Routes.career,
        builder: (context, state) => const CareerScreen(),
      ),
      GoRoute(
        path: Paths.otherDetails,
        name: Routes.otherDetails,
        builder: (context, state) => const OtherDetailsScreen(),
      ),
      GoRoute(
        path: Paths.connectMatches,
        name: Routes.connectMatches,
        builder: (context, state) => const ConnectMatches(),
      ),
      GoRoute(
        path: Paths.editProfile,
        name: Routes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Paths.profileSectionEdit,
        name: Routes.profileSectionEdit,
        builder: (context, state) {
          final extra = state.extra;
          String? sectionKey;

          if (extra is String) {
            sectionKey = extra;
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            final rawSection = map['section'];
            if (rawSection is String) {
              sectionKey = rawSection;
            }
          }

          final section = ProfileEditSectionX.fromKey(sectionKey);
          return ProfileSectionEditScreen(section: section);
        },
      ),
      GoRoute(
        path: Paths.contactInformation,
        name: Routes.contactInformation,
        builder: (context, state) => const ContactInformationScreen(),
      ),
      GoRoute(
        path: Paths.biodataGenerator,
        name: Routes.biodataGenerator,
        builder: (context, state) => const BioDataGeneratorScreen(),
      ),
      GoRoute(
        path: Paths.upgradePackage,
        name: Routes.upgradePackage,
        builder: (context, state) {
          final fromScreen =
              state.extra is String ? state.extra as String : null;
          return UpgradePackageScreen(fromScreen: fromScreen);
        },
      ),
      GoRoute(
        path: Paths.paymentWebView,
        name: Routes.paymentWebView,
        builder: (context, state) {
          final extra = state.extra;
          String redirectUrl = '';
          String? transactionId;
          String? tranId;

          if (extra is String) {
            redirectUrl = extra;
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            final rawUrl = map['redirectUrl'];
            final rawTransactionId = map['transactionId'];
            final rawTranId = map['tranId'];

            if (rawUrl is String) {
              redirectUrl = rawUrl;
            }
            if (rawTransactionId is String &&
                rawTransactionId.trim().isNotEmpty) {
              transactionId = rawTransactionId.trim();
            }
            if (rawTranId is String && rawTranId.trim().isNotEmpty) {
              tranId = rawTranId.trim();
            }
          }

          return PaymentWebViewScreen(
            redirectUrl: redirectUrl,
            transactionId: transactionId,
            tranId: tranId,
          );
        },
      ),
      GoRoute(
        path: Paths.premiumMatches,
        name: Routes.premiumMatches,
        builder: (context, state) => const HomeViewAllScreen(
          type: HomeViewAllType.premiumMatches,
        ),
      ),
      GoRoute(
        path: Paths.recentVisitors,
        name: Routes.recentVisitors,
        builder: (context, state) => const HomeViewAllScreen(
          type: HomeViewAllType.recentVisitors,
        ),
      ),
      GoRoute(
        path: Paths.governmentIdVerify,
        name: Routes.governmentIdVerify,
        builder: (context, state) => const GovernmentIdVerifyScreen(),
      ),
      GoRoute(
        path: Paths.identityVerification,
        name: Routes.identityVerification,
        builder: (context, state) => const IdentityVerificationScreen(),
      ),
      GoRoute(
        path: Paths.diditVerificationWebView,
        name: Routes.diditVerificationWebView,
        builder: (context, state) {
          final extra = state.extra;
          var verificationUrl = '';
          if (extra is String) {
            verificationUrl = extra;
          } else if (extra is Map) {
            final rawUrl = Map<String, dynamic>.from(extra)['verificationUrl'];
            if (rawUrl is String) {
              verificationUrl = rawUrl;
            }
          }
          return DiditVerificationWebViewScreen(
            verificationUrl: verificationUrl,
          );
        },
      ),
      GoRoute(
        path: Paths.matches,
        name: Routes.matches,
        builder: (context, state) => const MatchesScreen(),
      ),
      GoRoute(
        path: Paths.searchFilter,
        name: Routes.searchFilter,
        builder: (context, state) => const SearchFilterScreen(),
      ),
      GoRoute(
        path: Paths.newFilter,
        name: Routes.newFilter,
        builder: (context, state) => const NewFilterScreen(),
      ),
      GoRoute(
        path: Paths.myMatchFilter,
        name: Routes.myMatchFilter,
        builder: (context, state) => const MyMatchFilterScreen(),
      ),
      GoRoute(
        path: Paths.contactFilter,
        name: Routes.contactFilter,
        builder: (context, state) => const ContactFilterScreen(),
      ),
      GoRoute(
        path: Paths.accountSetting,
        name: Routes.accountSetting,
        builder: (context, state) => AccountSettingScreen(
          initialStep: state.extra is AccountSettingStep
              ? state.extra as AccountSettingStep
              : AccountSettingStep.accountSetting,
        ),
      ),
      GoRoute(
        path: Paths.phoneVerification,
        name: Routes.phoneVerification,
        builder: (context, state) => PhoneVerificationScreen(
          phone: state.extra is String ? state.extra as String : null,
        ),
      ),
      GoRoute(
        path: Paths.cropImage,
        name: Routes.cropImage,
        builder: (context, state) {
          final extra = state.extra;
          String? imagePath;
          final fromScreenFromQuery =
              state.uri.queryParameters['fromScreen']?.trim();
          String? fromScreen = fromScreenFromQuery?.isNotEmpty == true
              ? fromScreenFromQuery
              : null;

          if (extra is String) {
            imagePath = extra;
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            final rawImagePath = map['imagePath'];
            final rawFromScreen = map['fromScreen'];
            if (rawImagePath is String) {
              imagePath = rawImagePath;
            }
            if (fromScreen == null && rawFromScreen is String) {
              fromScreen = rawFromScreen.trim();
            }
          }

          return CropImageScreen(
            imagePath: imagePath,
            fromScreen: fromScreen,
          );
        },
      ),
      GoRoute(
        path: Paths.chatScreen,
        name: Routes.chatScreen,
        builder: (context, state) {
          final extra = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : null;
          return ChatScreen(extra: extra);
        },
      ),
      GoRoute(
        path: Paths.report,
        name: Routes.report,
        builder: (context, state) {
          final extra = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : null;
          final userName =
              extra != null ? (extra['displayName'] as String?) : null;
          return ReportScreen(userName: userName);
        },
      ),
      GoRoute(
        path: Paths.reportStatus,
        name: Routes.reportStatus,
        builder: (context, state) {
          final extra = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : const <String, dynamic>{};
          return StatusScreen(
            title: extra['title'] as String? ?? 'Report submitted',
            subtitle: extra['subtitle'] as String? ??
                'Thanks. Your report has been received and will be reviewed.',
            buttonText: extra['buttonText'] as String? ?? 'Done',
            onTapButton: extra['onTapButton'] as VoidCallback? ??
                () => Navigator.of(context).maybePop(),
          );
        },
      ),
      GoRoute(
        path: Paths.profilePreview,
        name: Routes.profilePreview,
        builder: (context, state) {
          final extra = state.extra is Map<String, dynamic>
              ? state.extra as Map<String, dynamic>
              : const <String, dynamic>{};
          final userId = extra['userId']?.toString() ?? '';
          return ProfilePreviewScreen(userId: userId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: Text('Error'.localized(context)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(Paths.splash),
              child: Text('Go to Home'.localized(context)),
            ),
          ],
        ),
      ),
    ),
  );
}
