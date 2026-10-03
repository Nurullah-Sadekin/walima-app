import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/home/data/model/response/recent_visitors_response.dart';
import 'package:walima_llc/features/matches/domain/enums/match_connection_state.dart';

void main() {
  test('parses visitor entitlement and engagement fields from response', () {
    final response = RecentVisitorsResponse.fromJson(
      <String, dynamic>{
        'code': 'SUCCESS',
        'message': 'visitors fetched',
        'response': <String, dynamic>{
          'hasRecentVisitorsFeature': false,
          'recentVisitorsFeatureKey': 'recent_visitors',
          'data': <dynamic>[
            <String, dynamic>{
              'id': 'visitor-1',
              'visitedAt': '2026-07-30T10:00:00Z',
              'visitCount': 3,
              'mutualView': true,
              'connection': <String, dynamic>{'status': 'blocked'},
            },
          ],
          'pagination': <String, dynamic>{
            'total': 14,
            'page': 1,
            'size': 10,
            'totalPages': 2,
          },
        },
        'traceId': 'trace-visitor',
      },
      statusCode: 200,
    );

    expect(response.isSuccess, isTrue);
    expect(response.response!.hasRecentVisitorsFeature, isFalse);
    expect(response.response!.recentVisitorsFeatureKey, 'recent_visitors');
    expect(response.response!.pagination!.hasNextPage, isTrue);
    expect(response.response!.data!.single.visitCount, 3);
    expect(response.response!.data!.single.mutualView, isTrue);
    expect(
      response.response!.data!.single.connectionState,
      MatchConnectionState.blocked,
    );
  });

  test('parses recently-viewed fields and legacy connectionStatus', () {
    final response = RecentVisitorsResponse.fromJson(<String, dynamic>{
      'code': 'SUCCESS',
      'response': <String, dynamic>{
        'data': <dynamic>[
          <String, dynamic>{
            'id': 'viewed-1',
            'viewedAt': '2026-07-30T11:00:00Z',
            'viewCount': 4,
            'connectionStatus': 'accepted',
          },
        ],
        'pagination': <String, dynamic>{
          'total': 1,
          'page': 1,
          'size': 10,
          'totalPages': 1,
        },
      },
    });

    final profile = response.response!.data!.single;
    expect(profile.viewCount, 4);
    expect(profile.connectionState, MatchConnectionState.accepted);
    expect(profile.canConnect, isFalse);
  });
}
