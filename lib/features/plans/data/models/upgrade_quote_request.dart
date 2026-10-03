class UpgradeQuoteRequestBody {
  UpgradeQuoteRequestBody({
    required this.targetPlanId,
    required this.billingCycle,
  });

  final String targetPlanId;
  final String billingCycle;

  Map<String, dynamic> toJson() {
    return {
      'targetPlanId': targetPlanId,
      'billingCycle': billingCycle,
    };
  }
}
