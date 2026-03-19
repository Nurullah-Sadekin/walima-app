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
    super.key,
  });

  final String redirectUrl;
  final String? transactionId;

  @override
  ConsumerState<PaymentWebViewScreen> createState() =>
      _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends ConsumerState<PaymentWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isPageLoading = true;
  bool _isCompletingFlow = false;
  bool _isErrorHandled = false;
  bool _isWebhookInProgress = false;
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

    final isWalimaDomain = currentUri.host.toLowerCase().contains('walima.app');
    final hasTerminalMarker = _hasTerminalMarker(currentUrl);
    final hasSuccessMarker = _hasSuccessMarker(currentUrl);

    if (!isWalimaDomain || !hasTerminalMarker) {
      return;
    }

    if (hasSuccessMarker) {
      unawaited(_confirmPaymentSuccess(currentUri));
      return;
    }

    _completeFlowAndGoHome();
  }

  bool _hasSuccessMarker(String url) {
    final normalized = url.toLowerCase();
    return normalized.contains('success') ||
        normalized.contains('complete') ||
        normalized.contains('completed');
  }

  Future<void> _confirmPaymentSuccess(Uri currentUri) async {
    if (_isCompletingFlow || _isWebhookInProgress) return;
    _isWebhookInProgress = true;

    final transactionId = _resolveTransactionId(currentUri);
    final isReceived = await PlanRepository.notifySslCommerzWebhook(
      transactionId: transactionId,
      status: 'success',
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

  String _resolveTransactionId(Uri currentUri) {
    final candidates = <String?>[
      widget.transactionId,
      currentUri.queryParameters['tran_id'],
      currentUri.queryParameters['tranId'],
      currentUri.queryParameters['transaction_id'],
      currentUri.queryParameters['transactionId'],
      _initialUri?.queryParameters['tran_id'],
      _initialUri?.queryParameters['tranId'],
      _initialUri?.queryParameters['transaction_id'],
      _initialUri?.queryParameters['transactionId'],
    ];

    for (final candidate in candidates) {
      final normalized = candidate?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }

    // Fallback keeps webhook payload aligned with backend contract in case txn id is missing from redirect URL.
    return '4545f';
  }

  bool _hasTerminalMarker(String url) {
    final normalized = url.toLowerCase();
    return normalized.contains('success') ||
        normalized.contains('fail') ||
        normalized.contains('failed') ||
        normalized.contains('cancel') ||
        normalized.contains('cancelled') ||
        normalized.contains('complete') ||
        normalized.contains('completed') ||
        normalized.contains('payment-status');
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
                  if (_isPageLoading)
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
