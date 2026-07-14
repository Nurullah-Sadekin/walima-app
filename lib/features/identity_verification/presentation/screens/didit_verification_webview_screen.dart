import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

/// Hosts the Didit hosted verification page in an in-app webview.
///
/// Flutter never owns verification state - when the user finishes or returns,
/// the parent screen re-reads `GET /verification/status` (the source of truth).
/// This screen only:
///  - loads the backend-provided `verificationUrl`,
///  - grants the webview camera/microphone request when the hosted flow asks,
///  - intercepts the Didit callback redirect (`didit=return`) so the localhost
///    callback page is never actually loaded on the device, and
///  - pops back with `true` when the flow appears complete, `false` otherwise.
class DiditVerificationWebViewScreen extends StatefulWidget {
  const DiditVerificationWebViewScreen({
    required this.verificationUrl,
    super.key,
  });

  final String verificationUrl;

  @override
  State<DiditVerificationWebViewScreen> createState() =>
      _DiditVerificationWebViewScreenState();
}

class _DiditVerificationWebViewScreenState
    extends State<DiditVerificationWebViewScreen> {
  InAppWebViewController? _webViewController;
  bool _isPageLoading = true;
  bool _isClosing = false;
  bool _isErrorHandled = false;
  Uri? _initialUri;

  @override
  void initState() {
    super.initState();
    _initialUri = Uri.tryParse(widget.verificationUrl.trim());

    if (!_hasValidUrl) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await DialogUtils.showErrorDialog(
          context: context,
          message: 'Invalid verification link. Please try again.',
        );
        _close(completed: false);
      });
    }
  }

  bool get _hasValidUrl =>
      _initialUri != null &&
      _initialUri!.scheme.isNotEmpty &&
      _initialUri!.host.isNotEmpty;

  Future<PermissionResponse?> _onPermissionRequest(
    InAppWebViewController controller,
    PermissionRequest permissionRequest,
  ) async {
    return PermissionResponse(
      resources: permissionRequest.resources,
      action: PermissionResponseAction.GRANT,
    );
  }

  NavigationActionPolicy _handleNavigationRequest(
    NavigationAction navigationAction,
  ) {
    final url = navigationAction.request.url;
    if (url != null && _isReturnCallback(url.toString())) {
      _close(completed: true);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  /// True when [url] is the post-verification callback the backend configured.
  bool _isReturnCallback(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final hasReturnMarker = uri.queryParameters['didit'] == 'return';
    final isCallbackPath =
        uri.path.toLowerCase().contains('identity-verification');
    final isDiditHost = uri.host.toLowerCase().contains('didit');

    return hasReturnMarker || (isCallbackPath && !isDiditHost);
  }

  Future<void> _handleWebViewError() async {
    if (_isErrorHandled || !mounted) return;
    _isErrorHandled = true;

    setState(() => _isPageLoading = false);
    await DialogUtils.showErrorDialog(
      context: context,
      message: 'Unable to load the verification page. Please try again.',
    );
    _close(completed: false);
  }

  Future<void> _handleBackNavigation() async {
    final controller = _webViewController;
    if (controller != null && await controller.canGoBack()) {
      await controller.goBack();
      return;
    }
    _close(completed: false);
  }

  void _close({required bool completed}) {
    if (_isClosing || !mounted) return;
    _isClosing = true;
    context.pop(completed);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Identity Verification'.localized(context)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => _close(completed: false),
            icon: const Icon(Icons.close),
          ),
        ),
        body: !_hasValidUrl
            ? const SizedBox.shrink()
            : Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest:
                        URLRequest(url: WebUri(_initialUri!.toString())),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      mediaPlaybackRequiresUserGesture: false,
                      allowsInlineMediaPlayback: true,
                    ),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onPermissionRequest: _onPermissionRequest,
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async =>
                            _handleNavigationRequest(navigationAction),
                    onLoadStart: (controller, url) {
                      if (mounted) setState(() => _isPageLoading = true);
                    },
                    onLoadStop: (controller, url) {
                      if (mounted) setState(() => _isPageLoading = false);
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
                      child: const Center(child: Loading()),
                    ),
                ],
              ),
      ),
    );
  }
}
