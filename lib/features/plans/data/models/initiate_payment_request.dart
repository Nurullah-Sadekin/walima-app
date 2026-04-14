class InitiatePaymentRequestBody {
  InitiatePaymentRequestBody({
    required this.gateway,
    required this.planId,
    required this.billingCycle,
  });

  final String gateway;
  final String planId;
  final String billingCycle;

  Map<String, dynamic> toJson() {
    return {
      'gateway': gateway,
      'planId': planId,
      'billingCycle': billingCycle,
    };
  }
}
