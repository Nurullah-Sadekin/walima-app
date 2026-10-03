import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/matches/domain/enums/match_connection_state.dart';

void main() {
  test('parses wrapped match payload, premium flag, and server pagination', () {
    final response = GetMatchesResponse.fromJson(
      <String, dynamic>{
        'code': 'SUCCESS',
        'message': 'matches fetched',
        'response': <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{
              'id': 'member-1',
              'userReference': 'W-1',
              'displayName': 'Member',
              'isPremium': true,
              'connection': <String, dynamic>{
                'status': 'pending',
                'direction': 'received',
              },
            },
          ],
          'pagination': <String, dynamic>{
            'total': 21,
            'page': 1,
            'size': 10,
            'totalPages': 3,
          },
        },
        'traceId': 'trace-match',
      },
      statusCode: 200,
    );

    expect(response.isSuccess, isTrue);
    expect(response.traceId, 'trace-match');
    expect(response.data, hasLength(1));
    expect(response.data!.single.isPremium, isTrue);
    expect(
      response.data!.single.connectionState,
      MatchConnectionState.received,
    );
    expect(response.data!.single.canConnect, isFalse);
    expect(response.pagination!.total, 21);
    expect(response.pagination!.hasNextPage, isTrue);
  });

  test('does not parse feature data from the top level', () {
    final response = GetMatchesResponse.fromJson(<String, dynamic>{
      'code': 'SUCCESS',
      'data': <dynamic>[
        <String, dynamic>{'id': 'wrong-level'},
      ],
      'pagination': <String, dynamic>{'total': 1},
    });

    expect(response.data, isNull);
    expect(response.pagination, isNull);
  });

  test('an error code is not treated as success solely because HTTP is 200',
      () {
    final response = GetMatchesResponse.fromJson(
      <String, dynamic>{
        'code': 'E_BAD_REQUEST',
        'message': 'Validation failed',
        'response': <String, dynamic>{
          'errors': <String, dynamic>{
            'type': <String>['Unsupported type'],
          },
        },
        'traceId': 'trace-error',
      },
      statusCode: 200,
    );

    expect(response.isSuccess, isFalse);
    expect(response.firstErrorFor('type'), 'Unsupported type');
  });

  test('parses the documented list-shaped error envelope', () {
    final response = GetMatchesResponse.fromJson(<String, dynamic>{
      'code': 'E_UNAUTHORIZED',
      'message': 'User access required',
      'response': <String, dynamic>{
        'errors': <String>['Authentication failed'],
      },
    });

    expect(response.isSuccess, isFalse);
    expect(response.firstErrorFor('general'), 'Authentication failed');
  });

  test('preserves photo visibility setting from short card payloads', () {
    final response = GetMatchesResponse.fromJson(<String, dynamic>{
      'code': 'SUCCESS',
      'response': <String, dynamic>{
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'member-1',
            'profilePhoto': <String, dynamic>{
              'url': 'https://cdn.walima.app/photo.webp',
              'visibilitySetting': 'visible_to_all',
            },
          },
        ],
      },
    });

    expect(
      response.data!.single.profilePhoto!.visibilitySetting,
      'visible_to_all',
    );
  });
}
