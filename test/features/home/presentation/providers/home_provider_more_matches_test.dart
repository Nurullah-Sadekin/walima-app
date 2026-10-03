import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/home/data/model/response/recent_visitors_response.dart';
import 'package:walima_llc/features/home/presentation/providers/home_provider.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';

void main() {
  test('changing user clears user-scoped match and engagement data', () {
    final provider = HomeProvider();
    provider.premiumMatches.add(MatchProfile(id: 'premium-1'));
    provider.recentVisitors.add(Data(id: 'visitor-1'));
    provider.recentlyViewed.add(Data(id: 'viewed-1'));
    provider.hasRecentVisitorsFeature = false;

    provider.setAuthenticatedUser('new-user');

    expect(provider.premiumMatches, isEmpty);
    expect(provider.recentVisitors, isEmpty);
    expect(provider.recentlyViewed, isEmpty);
    expect(provider.hasRecentVisitorsFeature, isNull);
  });
}
