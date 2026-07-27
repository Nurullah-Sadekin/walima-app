import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';

void main() {
  group('ProfileStrengthResponse', () {
    test('parses the response envelope and decimal section values', () {
      final response = ProfileStrengthResponse.fromJson(
        _envelope(
          score: 65,
          sectionScore: 11.4,
          sectionWeight: 20,
        ),
      );

      expect(response.isSuccess, isTrue);
      expect(response.traceId, 'trace-123');
      expect(response.response!.overallScore, 65);
      expect(response.response!.sections.single.weight, 20.0);
      expect(response.response!.sections.single.score, 11.4);
      expect(response.response!.tips, <String>['First tip', 'Second tip']);
      expect(
        response.response!.sections.single.firstIncompleteFieldKey,
        'religionPreference',
      );
    });

    test('accepts integer score values as doubles', () {
      final response = ProfileStrengthResponse.fromJson(
        _envelope(score: 100, sectionScore: 20, sectionWeight: 20),
      );

      expect(response.response!.sections.single.score, 20.0);
    });

    test('parses every currently known backend section key', () {
      const keys = <String>[
        'preferences',
        'basic_profile',
        'photos',
        'family',
        'education',
        'profession',
        'appearance',
        'religion',
        'lifestyle',
        'location',
        'interests',
        'contact',
      ];
      final envelope = _envelope(
        score: 50,
        sectionScore: 10,
        sectionWeight: 20,
      );
      final payload = envelope['response'] as Map<String, dynamic>;
      final template =
          (payload['sections'] as List<dynamic>).single as Map<String, dynamic>;
      payload['sections'] = keys
          .map(
            (key) => <String, dynamic>{
              ...template,
              'key': key,
              'label': key,
            },
          )
          .toList(growable: false);

      final response = ProfileStrengthResponse.fromJson(envelope);

      expect(
        response.response!.sections.map((section) => section.key),
        keys,
      );
    });

    test('preserves a non-success message and trace id', () {
      final response = ProfileStrengthResponse.fromJson(<String, dynamic>{
        'code': 'FAILED',
        'message': 'No access',
        'traceId': 'trace-failed',
      });

      expect(response.isSuccess, isFalse);
      expect(response.message, 'No access');
      expect(response.traceId, 'trace-failed');
      expect(response.response, isNull);
    });

    test('rejects a successful envelope without a response', () {
      expect(
        () => ProfileStrengthResponse.fromJson(<String, dynamic>{
          'code': 'SUCCESS',
          'message': 'Success',
          'traceId': 'trace-missing',
        }),
        throwsFormatException,
      );
    });

    test('rejects malformed section data', () {
      final malformed = _envelope(
        score: 20,
        sectionScore: 4,
        sectionWeight: 20,
      );
      (malformed['response'] as Map<String, dynamic>)['sections'] = <dynamic>[
        <String, dynamic>{'key': 'preferences'},
      ];

      expect(
        () => ProfileStrengthResponse.fromJson(malformed),
        throwsFormatException,
      );
    });
  });
}

Map<String, dynamic> _envelope({
  required int score,
  required num sectionScore,
  required num sectionWeight,
}) {
  return <String, dynamic>{
    'code': 'SUCCESS',
    'message': 'Success',
    'traceId': 'trace-123',
    'response': <String, dynamic>{
      'overallScore': score,
      'sections': <dynamic>[
        <String, dynamic>{
          'key': 'preferences',
          'label': 'Partner Preferences',
          'weight': sectionWeight,
          'score': sectionScore,
          'completionPercentage': score,
          'completed': score == 100,
          'fields': <dynamic>[
            <String, dynamic>{
              'key': 'ageRange',
              'label': 'Age Range',
              'completed': true,
            },
            <String, dynamic>{
              'key': 'religionPreference',
              'label': 'Religion Preference',
              'completed': false,
            },
          ],
        },
      ],
      'tips': <String>['First tip', 'Second tip'],
    },
  };
}
