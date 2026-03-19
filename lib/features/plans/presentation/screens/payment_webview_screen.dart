import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/plans/data/repository/plan_repository.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentWebViewScreen extends ConsumerStatefulWidget {
  const PaymentWebViewScreen({
    required this.redirectUrl,
    this.transactionId,
    this.tranId,
    super.key,
  });

  final String redirectUrl;
  final String? transactionId;
  final String? tranId;

  @override
  ConsumerState<PaymentWebViewScreen> createState() =>
      _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends ConsumerState<PaymentWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isPageLoading = true;
  bool _isCompletingFlow = false;
  bool _isErrorHandled = false;
  bool _isCallbackInProgress = false;
  bool _isFinalizingPayment = false;
  Uri? _initialUri;

  @override
  void initState() {
    super.initState();
    _initialUri = Uri.tryParse(widget.redirectUrl);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isInvalidUrl = _initialUri == null ||
          _initialUri!.scheme.isEmpty ||
          _initialUri!.host.isEmpty;
      if (!isInvalidUrl || !mounted) return;

      await DialogUtils.showErrorDialog(
        context: context,
        message: 'Invalid payment URL. Please try again.',
      );
      if (!mounted) return;
      context.go(Paths.anchor);
    });
  }

  Future<void> _handleBackNavigation() async {
    if (_webViewController != null) {
      final canGoBack = await _webViewController!.canGoBack();
      if (canGoBack) {
        await _webViewController!.goBack();
        return;
      }
    }

    _completeFlowAndGoHome();
  }

  void _completeFlowAndGoHome() {
    if (_isCompletingFlow || !mounted) return;
    _isCompletingFlow = true;
    context.go(Paths.anchor);
  }

  void _handleUrlChange(String? currentUrl) {
    if (_isCompletingFlow || currentUrl == null || currentUrl.isEmpty) return;

    final currentUri = Uri.tryParse(currentUrl);
    if (currentUri == null) return;

    if (_matchesSslCommerzCompletionPattern(currentUri)) {
      unawaited(_confirmPaymentSuccess(currentUri));
      return;
    }

    final isWalimaDomain = currentUri.host.toLowerCase().contains('walima.app');
    if (!isWalimaDomain) return;

    if (_hasFailureMarker(currentUrl)) {
      _completeFlowAndGoHome();
    }
  }

  Future<void> _confirmPaymentSuccess(Uri currentUri) async {
    if (_isCompletingFlow || _isCallbackInProgress) return;
    _isCallbackInProgress = true;
    if (mounted) {
      setState(() {
        _isFinalizingPayment = true;
      });
    }

    final callbackTransactionId = _resolveCallbackTransactionId(currentUri);
    final callbackValId = _resolveValId(currentUri);
    final callbackTranId = _resolveCallbackTranId(currentUri);

    if (callbackTransactionId.isEmpty ||
        callbackValId.isEmpty ||
        callbackTranId.isEmpty) {
      await DialogUtils.showErrorDialog(
        context: context,
        message:
            'Payment verification information is incomplete. Please try again.',
      );
      if (!mounted) return;
      _completeFlowAndGoHome();
      return;
    }

    final isReceived = await PlanRepository.confirmSslCommerzCallback(
      transactionId: callbackTransactionId,
      valId: callbackValId,
      tranId: callbackTranId,
      status: 'success',
      tranType: 'success',
    );

    if (!mounted) return;

    if (!isReceived) {
      await DialogUtils.showErrorDialog(
        context: context,
        message: 'Payment verification failed. Please try again.',
      );
      if (!mounted) return;
      _completeFlowAndGoHome();
      return;
    }

    await ref.read(profileProvider).getDashboard();
    if (!mounted) return;
    _completeFlowAndGoHome();
  }

  bool _matchesSslCommerzCompletionPattern(Uri uri) {
    final host = uri.host.toLowerCase();
    if (!host.contains('walima.app')) return false;

    final path = uri.path.toLowerCase();
    final gateway = _pickQueryParam(uri, const ['gateway']).toLowerCase();
    final valId = _resolveValId(uri);
    final transactionId =
        _pickQueryParam(uri, const ['transactionId', 'transaction_id']);

    return path.contains('/payment/success') &&
        gateway == 'sslcommerz' &&
        valId.isNotEmpty &&
        transactionId.isNotEmpty;
  }

  bool _hasFailureMarker(String url) {
    final normalized = url.toLowerCase();
    return normalized.contains('fail') ||
        normalized.contains('failed') ||
        normalized.contains('cancel') ||
        normalized.contains('cancelled');
  }

  String _resolveCallbackTransactionId(Uri currentUri) {
    final fromWidget = widget.transactionId?.trim() ?? '';
    if (fromWidget.isNotEmpty) return fromWidget;

    final fromInitial = _pickQueryParam(
      _initialUri,
      const ['paymentTransactionId', 'transactionId', 'transaction_id'],
    );
    if (fromInitial.isNotEmpty) return fromInitial;

    final fromCurrent = _pickQueryParam(
      currentUri,
      const ['paymentTransactionId', 'transactionId', 'transaction_id'],
    );
    if (fromCurrent.isNotEmpty) return fromCurrent;

    return '';
  }

  String _resolveCallbackTranId(Uri currentUri) {
    final fromWidget = widget.tranId?.trim() ?? '';
    if (fromWidget.isNotEmpty) return fromWidget;

    final fromCurrent =
        _pickQueryParam(currentUri, const ['tran_id', 'tranId']);
    if (fromCurrent.isNotEmpty) return fromCurrent;

    final fromCurrentTransaction =
        _pickQueryParam(currentUri, const ['transactionId', 'transaction_id']);
    if (fromCurrentTransaction.isNotEmpty) return fromCurrentTransaction;

    final fromInitial = _pickQueryParam(
      _initialUri,
      const ['tran_id', 'tranId', 'transactionId', 'transaction_id'],
    );
    if (fromInitial.isNotEmpty) return fromInitial;

    return '';
  }

  String _resolveValId(Uri currentUri) {
    final fromCurrent = _pickQueryParam(currentUri, const ['val_id', 'valId']);
    if (fromCurrent.isNotEmpty) return fromCurrent;

    return _pickQueryParam(_initialUri, const ['val_id', 'valId']);
  }

  String _pickQueryParam(Uri? uri, List<String> keys) {
    if (uri == null) return '';

    for (final key in keys) {
      final value = uri.queryParameters[key]?.trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  Future<void> _handleWebViewError() async {
    if (_isErrorHandled || !mounted) return;
    _isErrorHandled = true;

    setState(() => _isPageLoading = false);
    await DialogUtils.showErrorDialog(
      context: context,
      message: 'Unable to load the payment page. Please try again.',
    );

    if (!mounted) return;
    context.go(Paths.anchor);
  }

  @override
  Widget build(BuildContext context) {
    final isInvalidUrl = _initialUri == null ||
        _initialUri!.scheme.isEmpty ||
        _initialUri!.host.isEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          leading: IconButton(
            onPressed: _completeFlowAndGoHome,
            icon: const Icon(Icons.close),
          ),
        ),
        body: isInvalidUrl
            ? const SizedBox.shrink()
            : Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(widget.redirectUrl),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      if (mounted) {
                        setState(() => _isPageLoading = true);
                      }
                      _handleUrlChange(url?.toString());
                    },
                    onLoadStop: (controller, url) {
                      if (mounted) {
                        setState(() => _isPageLoading = false);
                      }
                      _handleUrlChange(url?.toString());
                    },
                    onReceivedError: (controller, request, error) {
                      _handleWebViewError();
                    },
                  ),
                  if (_isPageLoading || _isFinalizingPayment)
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                      child: const Center(
                        child: Loading(),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
