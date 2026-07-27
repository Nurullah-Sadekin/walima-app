import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/home/presentation/providers/home_provider.dart';

void main() {
  test('deduplicates simultaneous passive loads', () async {
    final completer = Completer<ProfileStrengthResponse>();
    var calls = 0;
    final provider = HomeProvider(profileStrengthLoader: () {
      calls++;
      return completer.future;
    });

    final first = provider.loadProfileStrength();
    final second = provider.loadProfileStrength();
    expect(calls, 1);

    completer.complete(_response(45));
    await Future.wait(<Future<void>>[first, second]);

    expect(provider.profileStrength!.overallScore, 45);
    expect(provider.isLoadingProfileStrength, isFalse);
  });

  test('keeps stale data when refresh fails', () async {
    final responses = <ProfileStrengthResponse>[
      _response(60),
      const ProfileStrengthResponse(
        code: 'FAILED',
        message: 'Network unavailable',
        traceId: 'trace-failure',
      ),
    ];
    final provider = HomeProvider(
      profileStrengthLoader: () async => responses.removeAt(0),
    );

    await provider.loadProfileStrength();
    await provider.loadProfileStrength(force: true);

    expect(provider.profileStrength!.overallScore, 60);
    expect(provider.profileStrengthError, 'Network unavailable');
    expect(provider.profileStrengthTraceId, 'trace-failure');
  });

  test('an older forced request cannot overwrite a newer response', () async {
    final first = Completer<ProfileStrengthResponse>();
    final second = Completer<ProfileStrengthResponse>();
    var calls = 0;
    final provider = HomeProvider(profileStrengthLoader: () {
      calls++;
      return calls == 1 ? first.future : second.future;
    });

    final olderLoad = provider.loadProfileStrength();
    final newerLoad = provider.loadProfileStrength(force: true);
    second.complete(_response(82));
    await newerLoad;
    first.complete(_response(15));
    await olderLoad;

    expect(provider.profileStrength!.overallScore, 82);
  });

  test('changing authenticated user discards an in-flight response', () async {
    final first = Completer<ProfileStrengthResponse>();
    final second = Completer<ProfileStrengthResponse>();
    var calls = 0;
    final provider = HomeProvider(profileStrengthLoader: () {
      calls++;
      return calls == 1 ? first.future : second.future;
    });

    provider.setAuthenticatedUser('user-a');
    final oldUserLoad = provider.loadProfileStrength();
    provider.setAuthenticatedUser('user-b');
    final newUserLoad = provider.loadProfileStrength();
    second.complete(_response(77));
    await newUserLoad;
    first.complete(_response(12));
    await oldUserLoad;

    expect(provider.profileStrength!.overallScore, 77);
  });
}

ProfileStrengthResponse _response(int score) {
  return ProfileStrengthResponse(
    code: 'SUCCESS',
    message: 'Success',
    traceId: 'trace-$score',
    response: ProfileStrengthData(
      overallScore: score,
      sections: <ProfileStrengthSection>[
        ProfileStrengthSection(
          key: 'preferences',
          label: 'Partner Preferences',
          weight: 20,
          score: score == 100 ? 20 : 10,
          completionPercentage: score,
          completed: score == 100,
          fields: const <ProfileStrengthField>[],
        ),
      ],
      tips: const <String>[],
    ),
  );
}
