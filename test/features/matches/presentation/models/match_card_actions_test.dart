import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/matches/presentation/models/match_card_actions.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';

void main() {
  MatchProfile matchWithStatus(String status) => MatchProfile.fromJson({
        'id': 'profile-1',
        'connection': {'status': status},
      });

  test('unconnected profiles show Shortlist and Connect', () {
    final actions =
        MatchCardActions(matchWithStatus('none'), isShortlisted: false);

    expect(actions.secondaryLabel, 'Shortlist');
    expect(actions.primaryLabel, 'Connect');
    expect(actions.showPrimaryButton, isTrue);
    expect(actions.showSecondaryButton, isTrue);
  });

  test('local shortlist changes the secondary label', () {
    final actions =
        MatchCardActions(matchWithStatus('none'), isShortlisted: true);

    expect(actions.secondaryLabel, 'Shortlisted');
  });

  test('accepted connections show Contact and Message', () {
    final actions = MatchCardActions(
      matchWithStatus('accepted'),
      isShortlisted: false,
    );

    expect(actions.secondaryLabel, 'Contact');
    expect(actions.primaryLabel, 'Message');
    expect(actions.showPrimaryButton, isTrue);
  });

  test('pending requests do not offer Connect or Contact', () {
    final actions = MatchCardActions(
      matchWithStatus('pending'),
      isShortlisted: false,
    );

    expect(actions.showPrimaryButton, isFalse);
    expect(actions.secondaryLabel, 'Shortlist');
  });
}
