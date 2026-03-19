import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    required this.redirectUrl,
    super.key,
  });

  final String redirectUrl;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isPageLoading = true;
  bool _isCompletingFlow = false;
  bool _isErrorHandled = false;
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

    if (isWalimaDomain && hasTerminalMarker) {
      _completeFlowAndGoHome();
    }
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
                    const Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(minHeight: 2),
                    ),
                ],
              ),
      ),
    );
  }
}
