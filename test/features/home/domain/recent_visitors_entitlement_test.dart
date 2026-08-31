import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/home/domain/recent_visitors_entitlement.dart';

void main() {
  test('free users only receive two unlocked visitors globally', () {
    expect(
      isRecentVisitorLocked(
        hasFeature: false,
        page: 1,
        size: 10,
        indexOnPage: 0,
      ),
      isFalse,
    );
    expect(
      isRecentVisitorLocked(
        hasFeature: false,
        page: 1,
        size: 10,
        indexOnPage: 1,
      ),
      isFalse,
    );
    expect(
      isRecentVisitorLocked(
        hasFeature: false,
        page: 1,
        size: 10,
        indexOnPage: 2,
      ),
      isTrue,
    );
    expect(
      isRecentVisitorLocked(
        hasFeature: false,
        page: 2,
        size: 10,
        indexOnPage: 0,
      ),
      isTrue,
    );
  });

  test('true or absent entitlement preserves access', () {
    for (final hasFeature in <bool?>[true, null]) {
      expect(
        isRecentVisitorLocked(
          hasFeature: hasFeature,
          page: 5,
          size: 10,
          indexOnPage: 9,
        ),
        isFalse,
      );
    }
  });
}
