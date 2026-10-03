import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/plans/data/models/get_current_subscription_response.dart';

void main() {
  group('CurrentSubscriptionData.hasPaidPlan', () {
    test('is false when the current plan is missing', () {
      final subscription = CurrentSubscriptionData(
        planId: 'free-plan-id',
      );

      expect(subscription.hasPaidPlan, isFalse);
    });

    test('is false for the free plan', () {
      final subscription = CurrentSubscriptionData(
        planId: 'free-plan-id',
        plan: CurrentSubscriptionPlan(
          id: 'free-plan-id',
          name: 'Free',
          slug: 'free',
        ),
      );

      expect(subscription.hasPaidPlan, isFalse);
    });

    test('is true when a paid package exists', () {
      final subscription = CurrentSubscriptionData(
        planId: 'paid-plan-id',
        plan: CurrentSubscriptionPlan(
          id: 'paid-plan-id',
          name: 'Harmony',
          slug: 'harmony',
        ),
      );

      expect(subscription.hasPaidPlan, isTrue);
    });
  });
}
