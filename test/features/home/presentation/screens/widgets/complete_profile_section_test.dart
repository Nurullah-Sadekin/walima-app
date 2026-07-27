import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/home/presentation/providers/home_provider.dart';
import 'package:walima_llc/features/home/presentation/screens/widgets/complete_profile_section.dart';
import 'package:walima_llc/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:walima_llc/generated/l10n/app_localizations.dart';

void main() {
  test('uses the web-compatible score color thresholds', () {
    expect(profileStrengthColor(49), const Color(0xFFF43F5E));
    expect(profileStrengthColor(50), const Color(0xFFF59E0B));
    expect(profileStrengthColor(79), const Color(0xFFF59E0B));
    expect(profileStrengthColor(80), const Color(0xFF10B981));
  });

  test('routes all known strength sections to typed destinations', () {
    expect(
      _target('preferences', 'ageRange').section,
      ProfileEditSection.preferenceBasicInfo,
    );
    expect(
      _target('preferences', 'locationPreference').section,
      ProfileEditSection.preferenceLocationDetails,
    );
    expect(
      _target('preferences', 'educationPreference').section,
      ProfileEditSection.preferenceEducationCareer,
    );
    expect(
      _target('preferences', 'dietPreference').section,
      ProfileEditSection.preferenceOtherDetails,
    );
    expect(
      _target('basic_profile', 'bio').section,
      ProfileEditSection.aboutYourself,
    );
    expect(
      _target('basic_profile', 'dateOfBirth').section,
      ProfileEditSection.basicDetails,
    );
    expect(_target('family').section, ProfileEditSection.familyDetails);
    expect(
      _target('education', 'hasEducation').section,
      ProfileEditSection.educationCareer,
    );
    expect(
      _target('profession', 'hasProfession').section,
      ProfileEditSection.educationCareer,
    );
    expect(_target('appearance').section, ProfileEditSection.basicDetails);
    expect(
      _target('religion').section,
      ProfileEditSection.religiousBackground,
    );
    expect(_target('lifestyle').section, ProfileEditSection.basicDetails);
    expect(_target('location').section, ProfileEditSection.location);
    expect(
      _target('interests').section,
      ProfileEditSection.hobbiesInterests,
    );
    expect(
      _target('photos').kind,
      ProfileStrengthNavigationKind.photos,
    );
    expect(
      _target('contact').kind,
      ProfileStrengthNavigationKind.contacts,
    );
    expect(
      _target('future_section').kind,
      ProfileStrengthNavigationKind.genericEditor,
    );
  });

  testWidgets('shows a card skeleton during the initial request',
      (tester) async {
    final pending = Completer<ProfileStrengthResponse>();
    final provider = HomeProvider(profileStrengthLoader: () => pending.future);
    unawaited(provider.loadProfileStrength());

    await tester.pumpWidget(_app(provider));

    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('shows an inline retry state for an initial error',
      (tester) async {
    final provider = HomeProvider(
      profileStrengthLoader: () async => const ProfileStrengthResponse(
        code: 'FAILED',
        message: 'Network failed',
      ),
    );
    await provider.loadProfileStrength();

    await tester.pumpWidget(_app(provider));

    expect(find.text('Profile Strength'), findsOneWidget);
    expect(
      find.text('Profile strength is unavailable right now.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining('0%'), findsNothing);
  });

  testWidgets('renders every section, completed divider, and all tips',
      (tester) async {
    final provider = HomeProvider(
      profileStrengthLoader: () async => _response(score: 72),
    );
    await provider.loadProfileStrength();

    await tester.pumpWidget(_app(provider));

    expect(find.text('Partner Preferences'), findsOneWidget);
    expect(find.text('Basic Profile'), findsOneWidget);
    expect(find.text('Profile Photos'), findsOneWidget);
    expect(find.text('Contact Information'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Tips to improve'), findsOneWidget);
    expect(find.text('First returned tip'), findsOneWidget);
    expect(find.text('Second returned tip'), findsOneWidget);
    expect(find.text('57%'), findsOneWidget);
    expect(find.text('100%'), findsNWidgets(2));
  });

  testWidgets('hides the card only for a valid 100 score', (tester) async {
    final provider = HomeProvider(
      profileStrengthLoader: () async => _response(score: 100),
    );
    await provider.loadProfileStrength();

    await tester.pumpWidget(_app(provider));

    expect(find.text('Profile Strength'), findsNothing);
  });
}

Widget _app(HomeProvider provider) {
  return ProviderScope(
    overrides: <Override>[
      homeProvider.overrideWith((ref) => provider),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: SingleChildScrollView(child: CompleteProfileSection()),
      ),
    ),
  );
}

ProfileStrengthResponse _response({required int score}) {
  return ProfileStrengthResponse(
    code: 'SUCCESS',
    message: 'Success',
    response: ProfileStrengthData(
      overallScore: score,
      sections: <ProfileStrengthSection>[
        _section('preferences', 'Partner Preferences', 20, 57, false),
        _section('basic_profile', 'Basic Profile', 18, 67, false),
        _section('photos', 'Profile Photos', 15, 100, true),
        _section('contact', 'Contact Information', 2, 100, true),
      ],
      tips: const <String>['First returned tip', 'Second returned tip'],
    ),
  );
}

ProfileStrengthSection _section(
  String key,
  String label,
  double weight,
  int percentage,
  bool completed,
) {
  return ProfileStrengthSection(
    key: key,
    label: label,
    weight: weight,
    score: weight * percentage / 100,
    completionPercentage: percentage,
    completed: completed,
    fields: const <ProfileStrengthField>[],
  );
}

ProfileStrengthNavigationTarget _target(String sectionKey, [String? fieldKey]) {
  return resolveProfileStrengthNavigationTarget(
    ProfileStrengthSection(
      key: sectionKey,
      label: sectionKey,
      weight: 1,
      score: 0,
      completionPercentage: 0,
      completed: false,
      fields: fieldKey == null
          ? const <ProfileStrengthField>[]
          : <ProfileStrengthField>[
              ProfileStrengthField(
                key: fieldKey,
                label: fieldKey,
                completed: false,
              ),
            ],
    ),
  );
}
