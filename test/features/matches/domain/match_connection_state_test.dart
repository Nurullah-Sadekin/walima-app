import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/matches/domain/enums/match_connection_state.dart';

void main() {
  group('normalizeMatchConnectionState', () {
    test('normalizes all backend aliases', () {
      expect(normalizeMatchConnectionState(null), MatchConnectionState.none);
      expect(
        normalizeMatchConnectionState('pending', direction: 'sent'),
        MatchConnectionState.requested,
      );
      expect(
        normalizeMatchConnectionState('PENDING', direction: 'received'),
        MatchConnectionState.received,
      );
      expect(
        normalizeMatchConnectionState('accept'),
        MatchConnectionState.accepted,
      );
      expect(
        normalizeMatchConnectionState('rejected'),
        MatchConnectionState.declined,
      );
      expect(
        normalizeMatchConnectionState('cancel'),
        MatchConnectionState.cancelled,
      );
      expect(
        normalizeMatchConnectionState('blocked'),
        MatchConnectionState.blocked,
      );
      expect(
        normalizeMatchConnectionState('expired'),
        MatchConnectionState.expired,
      );
    });

    test('only reconnectable states expose Connect', () {
      expect(MatchConnectionState.none.canConnect, isTrue);
      expect(MatchConnectionState.cancelled.canConnect, isTrue);
      expect(MatchConnectionState.expired.canConnect, isTrue);
      expect(MatchConnectionState.requested.canConnect, isFalse);
      expect(MatchConnectionState.received.canConnect, isFalse);
      expect(MatchConnectionState.accepted.canConnect, isFalse);
      expect(MatchConnectionState.blocked.canConnect, isFalse);
    });
  });
}
