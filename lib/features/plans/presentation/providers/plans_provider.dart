import 'package:flutter/material.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/plans/data/models/get_current_subscription_response.dart';
import 'package:walima_llc/features/plans/data/models/get_plans_response.dart';
import 'package:walima_llc/features/plans/data/models/initiate_payment_request.dart';
import 'package:walima_llc/features/plans/data/models/initiate_payment_response.dart';
import 'package:walima_llc/features/plans/data/models/upgrade_quote_request.dart';
import 'package:walima_llc/features/plans/data/models/upgrade_quote_response.dart';
import 'package:walima_llc/features/plans/data/repository/plan_repository.dart';
import 'package:walima_llc/features/plans/domain/upgrade_package_model.dart';

class PlansProvider extends BaseChangeNotifier {
  // current selected page index for carousel
  int selectedPage = 0;
  List<Plans> packages = [];
  UpgradeQuoteData? latestUpgradeQuote;
  InitiatePaymentData? latestPaymentSession;
  CurrentSubscriptionData? currentSubscription;
  bool _subscriptionResolved = false;
  bool _subscriptionFetchSucceeded = true;

  String? get currentPlanId {
    final planId = currentSubscription?.planId?.trim();
    if (planId?.isNotEmpty == true) return planId;

    final nestedPlanId = currentSubscription?.plan?.id?.trim();
    if (nestedPlanId?.isNotEmpty == true) return nestedPlanId;

    return null;
  }

  int? get currentPlanRanking => currentSubscription?.plan?.ranking;

  bool get hasCurrentSubscription => currentPlanId?.isNotEmpty == true && currentSubscription?.plan?.slug != 'free';

  bool get hasResolvedCurrentSubscription => _subscriptionResolved;

  bool get hasSubscriptionFetchSucceeded => _subscriptionFetchSucceeded;

  final Map<String, String> haveQuestion = {
    'What are the benefits of upgrading?':
        'Upgraded members can send unlimited messages, view more contact numbers, and access additional profile details. You’ll also appear higher in searches, giving you better chances of connecting.',
    'How do I know if profiles are genuine?':
        'Every profile goes through a screening process to ensure authenticity. We also encourage members to report anything suspicious so we can act quickly.',
    'Can I pause my subscription?':
        'Yes, you can temporarily pause your subscription if you need a break. During this time, your profile will not appear in searches until you reactivate it.',
    'What support do you provide?':
        'Our support team is here to assist with account, payment, or profile-related questions. You can contact us anytime through chat, email, or phone support.',
  };

  final List<UpgradePackageItem> packageItems = packageItemsDataInserted;
  UpgradePackageScreenStates screenStates = UpgradePackageScreenStates.complete;
  UpgradePackageScreenStates loaderState = UpgradePackageScreenStates.complete;

  void changePage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  Future<void> fetchUpgradePackages() async {
    updateViewState(loadingState: UpgradePackageScreenStates.loading);
    final response = await PlanRepository.getAllPlans();
    if (response.packages != null) {
      //have to remove the free plan from the list of packages
      final plansAfterRemoveFree = response.packages!
          .where((plan) => plan.name?.toLowerCase() != 'free')
          .toList();
      packages = plansAfterRemoveFree;
    }
    updateViewState(loadingState: UpgradePackageScreenStates.complete);
  }

  Future<void> fetchCurrentSubscription({bool forceRefresh = false}) async {
    if (_subscriptionResolved && !forceRefresh) return;

    final response = await PlanRepository.getCurrentSubscription();
    _subscriptionResolved = true;
    _subscriptionFetchSucceeded = response.code == 'SUCCESS';

    if (response.code == 'SUCCESS') {
      currentSubscription = response.response?.data;
    } else {
      currentSubscription = null;
    }

    notifyListeners();
  }

  Future<String?> startPlanPurchase({
    required BuildContext context,
    required Plans selectedPlan,
  }) async {
    updateViewState(screenStates: UpgradePackageScreenStates.transparent);

    if (!hasResolvedCurrentSubscription || !hasSubscriptionFetchSucceeded) {
      await fetchCurrentSubscription(
        forceRefresh: true,
      );
    }

    if (!context.mounted) {
      updateViewState(screenStates: UpgradePackageScreenStates.complete);
      return null;
    }

    if (!hasSubscriptionFetchSucceeded) {
      return _handlePurchaseError(
        context,
        'Unable to verify current plan. Please try again.',
      );
    }

    final purchaseInput = _resolvePurchaseInput(selectedPlan);
    if (purchaseInput == null) {
      return _handlePurchaseError(
        context,
        'Selected package is invalid. Please try another package.',
      );
    }

    final hasExistingPlan = hasCurrentSubscription;

    if (hasExistingPlan) {
      final quoteData = _hasMatchingLatestQuote(purchaseInput)
          ? latestUpgradeQuote
          : await _fetchAndValidateQuote(
              context: context,
              purchaseInput: purchaseInput,
            );
      if (quoteData == null) return null;
      if (!context.mounted) {
        updateViewState(screenStates: UpgradePackageScreenStates.complete);
        return null;
      }
    }

    final paymentData = await _initiatePaymentSession(
      context: context,
      purchaseInput: purchaseInput,
      isUpgrade: hasExistingPlan,
    );
    if (paymentData == null) return null;

    latestPaymentSession = paymentData;
    updateViewState(screenStates: UpgradePackageScreenStates.complete);
    return paymentData.redirectUrl?.trim();
  }

  Future<PlanOrderSummaryPreview?> prepareOrderSummaryPreview({
    required BuildContext context,
    required Plans selectedPlan,
  }) async {
    updateViewState(screenStates: UpgradePackageScreenStates.transparent);

    final purchaseInput = _resolvePurchaseInput(selectedPlan);
    if (purchaseInput == null) {
      return _handleOrderSummaryError(
        context,
        'Selected package is invalid. Please try another package.',
      );
    }

    final quoteData = _hasMatchingLatestQuote(purchaseInput)
        ? latestUpgradeQuote
        : await _fetchAndValidateQuote(
            context: context,
            purchaseInput: purchaseInput,
          );
    if (quoteData == null) {
      return null;
    }

    updateViewState(screenStates: UpgradePackageScreenStates.complete);
    return PlanOrderSummaryPreview(
      isUpgrade: true,
      upgradeQuote: quoteData,
    );
  }

  _PurchaseInput? _resolvePurchaseInput(Plans selectedPlan) {
    final targetPlanId = selectedPlan.id?.trim() ?? '';
    if (targetPlanId.isEmpty) return null;

    final billingCycle = selectedPlan.pricings?.firstOrNull?.billingCycle
            ?.trim()
            .toLowerCase() ??
        'monthly';

    return _PurchaseInput(
      targetPlanId: targetPlanId,
      billingCycle: billingCycle,
    );
  }

  Future<UpgradeQuoteData?> _fetchAndValidateQuote({
    required BuildContext context,
    required _PurchaseInput purchaseInput,
  }) async {
    final quoteResponse = await PlanRepository.getUpgradeQuote(
      UpgradeQuoteRequestBody(
        targetPlanId: purchaseInput.targetPlanId,
        billingCycle: purchaseInput.billingCycle,
      ),
    );

    if (!context.mounted) {
      updateViewState(screenStates: UpgradePackageScreenStates.complete);
      return null;
    }

    if (quoteResponse.code != 'SUCCESS') {
      await _handlePurchaseError(
        context,
        quoteResponse.message ?? 'Unable to calculate upgrade quote.',
      );
      return null;
    }

    final quoteData = quoteResponse.response?.data;
    if (quoteData == null) {
      await _handlePurchaseError(
        context,
        'Upgrade quote is unavailable right now. Please try again.',
      );
      return null;
    }

    latestUpgradeQuote = quoteData;

    if (quoteData.canMove != true) {
      await _handlePurchaseError(
        context,
        quoteData.reason ?? 'Only higher-rank paid plan upgrade is allowed.',
      );
      return null;
    }

    return quoteData;
  }

  bool _hasMatchingLatestQuote(_PurchaseInput purchaseInput) {
    final quote = latestUpgradeQuote;
    if (quote == null) return false;

    final targetPlanId = quote.targetPlan?.id?.trim() ?? '';
    final billingCycle = (quote.billingCycle ?? '').trim().toLowerCase();

    return targetPlanId == purchaseInput.targetPlanId &&
        billingCycle == purchaseInput.billingCycle;
  }

  Future<InitiatePaymentData?> _initiatePaymentSession({
    required BuildContext context,
    required _PurchaseInput purchaseInput,
    required bool isUpgrade,
  }) async {
    final requestBody = InitiatePaymentRequestBody(
      gateway: 'sslcommerz',
      planId: purchaseInput.targetPlanId,
      billingCycle: purchaseInput.billingCycle,
    );

    final initiateResponse = isUpgrade
        ? await PlanRepository.initiateUpgradePayment(requestBody)
        : await PlanRepository.initiatePayment(requestBody);

    if (!context.mounted) {
      updateViewState(screenStates: UpgradePackageScreenStates.complete);
      return null;
    }

    if (initiateResponse.code != 'SUCCESS') {
      await _handlePurchaseError(
        context,
        initiateResponse.message ??
            (isUpgrade
                ? 'Failed to initiate upgrade payment.'
                : 'Failed to initiate payment.'),
      );
      return null;
    }

    final paymentData = initiateResponse.response?.data;
    final redirectUrl = paymentData?.redirectUrl?.trim() ?? '';
    if (paymentData == null || redirectUrl.isEmpty) {
      await _handlePurchaseError(
        context,
        'Payment redirect URL is missing. Please try again.',
      );
      return null;
    }

    return paymentData;
  }

  Future<String?> _handlePurchaseError(
    BuildContext context,
    String message,
  ) async {
    updateViewState(screenStates: UpgradePackageScreenStates.complete);
    if (context.mounted) {
      await DialogUtils.showErrorDialog(
        context: context,
        message: message,
      );
    }
    return null;
  }

  Future<PlanOrderSummaryPreview?> _handleOrderSummaryError(
    BuildContext context,
    String message,
  ) async {
    updateViewState(screenStates: UpgradePackageScreenStates.complete);
    if (context.mounted) {
      await DialogUtils.showErrorDialog(
        context: context,
        message: message,
      );
    }
    return null;
  }

  void updateViewState({
    UpgradePackageScreenStates? screenStates,
    UpgradePackageScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = UpgradePackageScreenStates.complete;
    }
    if (loadingState != null) {
      loaderState = loadingState;
    }
    notifyListeners();
  }
}

class _PurchaseInput {
  _PurchaseInput({
    required this.targetPlanId,
    required this.billingCycle,
  });

  final String targetPlanId;
  final String billingCycle;
}

enum UpgradePackageScreenStates {
  transparent,
  complete,
  loading,
}

extension _ListSafeAccess<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class PlanOrderSummaryPreview {
  PlanOrderSummaryPreview({
    required this.isUpgrade,
    this.upgradeQuote,
  });

  final bool isUpgrade;
  final UpgradeQuoteData? upgradeQuote;
}
