import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/features/home/presentation/screens/edit_profile.dart';
import 'package:flutter_boilerplate/features/login/presentation/screens/new_password.dart';
import 'package:flutter_boilerplate/features/login/presentation/screens/otp_verify.dart';
import 'package:flutter_boilerplate/features/login/presentation/screens/reset_pssword_status.dart';
import 'package:flutter_boilerplate/features/login/presentation/screens/send_otp.dart';
import 'package:flutter_boilerplate/features/matches/presentation/screens/matches.dart';
import 'package:flutter_boilerplate/features/matches/presentation/screens/search_metches.dart';
import 'package:flutter_boilerplate/features/onboarding_screen.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/connect_matches.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/basic_details.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/career.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/community.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/education.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/other_details.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/partner_preferences.dart';
import 'package:flutter_boilerplate/features/recommended_preferences/presentation/recommended_preferences/preference_location.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/crop_image.dart';
import 'package:flutter_boilerplate/features/plans/presentation/screens/plans_screen.dart';
import 'package:flutter_boilerplate/features/plans/presentation/screens/payment_webview_screen.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/about_you.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/email_phone.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/family_details.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/family_financial_status.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/hobbies_interests.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/photo_upload.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/profile_created_status.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/profile_is_for.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/verify_otp_for_sign_up.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/your_religion.dart';
import 'package:flutter_boilerplate/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_boilerplate/features/splash_screen.dart';
import 'package:flutter_boilerplate/features/anchor_point/anchor_point.dart';
import 'package:flutter_boilerplate/features/login/presentation/login_screen.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/location.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/marital_status.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/qualification.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/profession.dart';
import 'package:flutter_boilerplate/features/registration/presentation/screens/about_yourself.dart';
import '../../features/chat/presentation/screens/one_to_one_chat_screen.dart';
import 'route_name.dart';
part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: Paths.splash,
    debugLogDiagnostics: true,
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
        builder: (context, state) => const YourReligion(),
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
      // GoRoute(
      //   path: Paths.verifyNumber,
      //   name: Routes.verifyNumber,
      //   builder: (context, state) => const VerifyNumberScreen(),
      // ),
      GoRoute(
        path: Paths.photoUpload,
        name: Routes.photoUpload,
        builder: (context, state) => const PhotoUploadScreen(),
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
        builder: (context, state) => const PartnerPreferencesScreen(),
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

          if (extra is String) {
            redirectUrl = extra;
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            final rawUrl = map['redirectUrl'];
            final rawTransactionId = map['transactionId'];

            if (rawUrl is String) {
              redirectUrl = rawUrl;
            }
            if (rawTransactionId is String &&
                rawTransactionId.trim().isNotEmpty) {
              transactionId = rawTransactionId.trim();
            }
          }

          return PaymentWebViewScreen(
            redirectUrl: redirectUrl,
            transactionId: transactionId,
          );
        },
      ),
      GoRoute(
        path: Paths.matches,
        name: Routes.matches,
        builder: (context, state) => const MatchesScreen(),
      ),
      GoRoute(
        path: Paths.searchMatches,
        name: Routes.searchMatches,
        builder: (context, state) => const SearchMatchesScreen(),
      ),
      GoRoute(
        path: Paths.cropImage,
        name: Routes.cropImage,
        builder: (context, state) {
          final imagePath =
              state.extra is String ? state.extra as String : null;
          return CropImageScreen(imagePath: imagePath);
        },
      ),

      GoRoute(
        path: Paths.chatScreen,
        name: Routes.chatScreen,
        builder: (context, state) {
          // final imagePath = state.extra is String ? state.extra as String : null;
          return const ChatScreen();
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
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
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
