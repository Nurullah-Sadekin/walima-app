import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/identity_verification/data/models/identity_verification_models.dart';
import 'package:walima_llc/features/identity_verification/presentation/providers/identity_verification_provider.dart';

/// Identity verification (Didit KYC) screen.
///
/// Follows FLUTTER_DIDIT_IDENTITY_VERIFICATION_GUIDE.md:
///  - On open, reads `GET /verification/status`; display state uses the
///    latest session status first, then the user status (§4).
///  - Start / Resume / Try again all call `POST /verification/session` (the
///    backend reuses an active session) and open the hosted page.
///  - On return, re-reads status in a short bounded burst; returning never
///    proves approval. Cached `/auth/me` is refreshed so badges catch up.
///  - Cancel (`DELETE`) only for cancellable sessions, after confirmation.
class IdentityVerificationScreen extends ConsumerStatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  ConsumerState<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends ConsumerState<IdentityVerificationScreen> {
  bool _isLaunchingFlow = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  /// Reads backend status, then refreshes the cached current user so the
  /// home/drawer badges reflect it.
  Future<void> _refresh({bool burst = false}) async {
    final ok = await ref.read(identityVerificationProvider).loadStatus(
          burst: burst,
          keepGoing: () =>
              mounted &&
              WidgetsBinding.instance.lifecycleState ==
                  AppLifecycleState.resumed,
        );
    if (!ok || !mounted) return;
    await ref
        .read(globalProvider)
        .refreshCurrentUserAndQuota(silent: true, force: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(identityVerificationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(
        backgroundColor: Colors.white,
        backIconBackground: Colors.transparent,
        title: Text(
          'Identity Verification'.localized(context),
          style: const TextStyle(color: AppColors.textPrimaryLight),
        ),
        trailingWidget: IconButton(
          tooltip: 'Refresh'.localized(context),
          onPressed: provider.isLoadingStatus ? null : () => _refresh(),
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    IdentityVerificationProvider provider,
  ) {
    if (provider.isLoadingStatus && !provider.hasLoadedStatus) {
      return const Center(child: Loading());
    }

    if (!provider.hasLoadedStatus && provider.statusError != null) {
      return _ErrorRetry(
        message: provider.statusError!,
        onRetry: () => _refresh(),
      );
    }

    final state = provider.verificationState;
    final view = _VerificationView.of(state, provider.isUnderReview);

    return RefreshIndicator(
      onRefresh: () => _refresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height * 0.6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.isLoadingStatus)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryVariant,
                  ),
                ),
              if (provider.statusError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    provider.statusError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: TextSize.font13(context),
                    ),
                  ),
                ),
              _StatusHero(view: view),
              const SizedBox(height: 24),
              if (state != IdentityVerificationState.approved)
                _InfoChecklist(state: state),
              _LatestSessionInfo(session: provider.latestSession),
              const SizedBox(height: 28),
              ..._buildActions(context, provider, state),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    IdentityVerificationProvider provider,
    IdentityVerificationState state,
  ) {
    final busy = _isLaunchingFlow ||
        provider.isCreatingSession ||
        provider.isCancelling ||
        provider.isLoadingStatus;

    if (state == IdentityVerificationState.approved) {
      return [
        PrimaryButtons(
          buttonStyle: ButtonsStyle.activeSecondaryButton,
          onTap: () => context.pop(),
          title: 'Done',
        ),
      ];
    }

    // Start for not-submitted/rejected; Resume for an eligible unfinished
    // session (guide §4). Under-review sessions get neither.
    final showStart = provider.canStart || provider.canResume;
    final startTitle = provider.canResume
        ? 'Resume verification'
        : state == IdentityVerificationState.rejected
            ? 'Try again'
            : 'Start verification';

    return [
      if (showStart) ...[
        PrimaryButtons(
          buttonStyle: busy
              ? ButtonsStyle.disableButton
              : ButtonsStyle.activePrimaryButton,
          onTap: busy ? () {} : _launchFlow,
          title: _isLaunchingFlow || provider.isCreatingSession
              ? 'Please wait...'
              : startTitle,
        ),
        const SizedBox(height: 12),
      ],
      PrimaryButtons(
        buttonStyle: showStart
            ? ButtonsStyle.activeSecondaryButton
            : ButtonsStyle.activePrimaryButton,
        onTap: busy ? () {} : () => _refresh(),
        title: 'Refresh status',
      ),
      if (provider.canCancel) ...[
        const SizedBox(height: 4),
        TextButton(
          onPressed: busy ? null : _confirmCancel,
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: Text('Cancel verification'.localized(context)),
        ),
      ],
    ];
  }

  /// Creates (or reuses) a session, opens the hosted page, then re-reads the
  /// backend status. The backend returns the active session when one exists,
  /// so Start and Resume share this path.
  Future<void> _launchFlow() async {
    if (_isLaunchingFlow) return;
    setState(() => _isLaunchingFlow = true);

    final provider = ref.read(identityVerificationProvider);

    try {
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final requested = await Permission.camera.request();
        if (!requested.isGranted) {
          _showSnack(
            'Camera permission is required to complete verification.',
          );
          return;
        }
      }

      final session = await provider.startSession();
      if (!mounted) return;
      if (session == null) {
        _showSnack(
          provider.statusError ?? 'Unable to start verification right now.',
        );
        return;
      }

      final rawUrl = session.verificationUrl;
      final uri = rawUrl == null ? null : Uri.tryParse(rawUrl);
      if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
        _showSnack('Verification link is unavailable. Refresh and retry.');
        return;
      }

      await context.pushNamed<bool>(
        Routes.diditVerificationWebView,
        extra: uri.toString(),
      );
      if (!mounted) return;
    } finally {
      if (mounted) setState(() => _isLaunchingFlow = false);
    }

    // Closing/returning never proves approval; the backend may still be
    // syncing, so re-read a few times while it is still `Not Started`.
    await _refresh(burst: true);
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cancel verification?'.localized(dialogContext)),
        content: Text(
          'This deletes the unfinished verification session and captured data. You can start again afterward.'
              .localized(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Keep session'.localized(dialogContext)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Cancel verification'.localized(dialogContext)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final error = await ref.read(identityVerificationProvider).cancelSession();
    if (!mounted) return;
    _showSnack(error ?? 'Verification cancelled.');
    await ref
        .read(globalProvider)
        .refreshCurrentUserAndQuota(silent: true, force: true);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Visual configuration for a verification state.
class _VerificationView {
  const _VerificationView({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String description;

  static _VerificationView of(
    IdentityVerificationState state,
    bool isUnderReview,
  ) {
    switch (state) {
      case IdentityVerificationState.approved:
        return const _VerificationView(
          icon: Icons.verified_rounded,
          accentColor: AppColors.success,
          title: 'Identity verified',
          description:
              'Your identity has been verified. The verified badge now appears on your profile.',
        );
      case IdentityVerificationState.pending:
        return isUnderReview
            ? const _VerificationView(
                icon: Icons.hourglass_top_rounded,
                accentColor: AppColors.warning,
                title: 'Under review',
                description:
                    'We have received your details and are reviewing them. This can take a little while — check back or refresh for updates.',
              )
            : const _VerificationView(
                icon: Icons.pending_actions_rounded,
                accentColor: AppColors.warning,
                title: 'Verification in progress',
                description:
                    'Your verification has started but is not finished yet. Complete any remaining steps, or refresh for updates.',
              );
      case IdentityVerificationState.rejected:
        return const _VerificationView(
          icon: Icons.error_outline_rounded,
          accentColor: AppColors.error,
          title: 'Verification needs attention',
          description:
              'Your verification could not be completed. Please review your documents and try again.',
        );
      case IdentityVerificationState.notSubmitted:
        return const _VerificationView(
          icon: Icons.verified_user_outlined,
          accentColor: AppColors.primary,
          title: 'Verify your identity',
          description:
              'Confirm your identity to earn a verified badge and help others trust your profile.',
        );
      case IdentityVerificationState.unknown:
        return const _VerificationView(
          icon: Icons.shield_outlined,
          accentColor: AppColors.info,
          title: 'Verification status',
          description:
              'We could not determine your verification status. Pull to refresh or try again shortly.',
        );
    }
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.view});

  final _VerificationView view;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: view.accentColor.withValues(alpha: 0.10),
          ),
          child: Icon(view.icon, size: 48, color: view.accentColor),
        ),
        const SizedBox(height: 20),
        Text(
          view.title.localized(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font18(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          view.description.localized(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

/// A short "what to expect" checklist shown before/while verifying.
class _InfoChecklist extends StatelessWidget {
  const _InfoChecklist({required this.state});

  final IdentityVerificationState state;

  @override
  Widget build(BuildContext context) {
    final items = state == IdentityVerificationState.pending
        ? const [
            'Your documents have been submitted securely.',
            'A reviewer or automated check is verifying them.',
            'You will receive the verified badge once approved.',
          ]
        : const [
            'Have a government ID ready (passport, ID card or licence).',
            'Verification opens a secure page to capture your details.',
            'It only takes a couple of minutes to complete.',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.disableBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    items[i].localized(context),
                    style: TextStyle(
                      color: AppColors.textSecondaryLight,
                      fontSize: TextSize.font13(context),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Subtle footer showing the latest Didit session details, when available.
class _LatestSessionInfo extends StatelessWidget {
  const _LatestSessionInfo({required this.session});

  final LatestSession? session;

  @override
  Widget build(BuildContext context) {
    final current = session;
    if (current == null || current.status.isEmpty) {
      return const SizedBox.shrink();
    }

    final updated = current.updatedAt ?? current.createdAt;
    final updatedLabel = updated == null ? null : _formatDate(updated);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Divider(height: 1, color: AppColors.dividerLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest session'.localized(context),
                style: TextStyle(
                  color: AppColors.hintTextColor,
                  fontSize: TextSize.font12(context),
                ),
              ),
              Text(
                current.status,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (updatedLabel != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Updated'.localized(context),
                  style: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: TextSize.font12(context),
                  ),
                ),
                Text(
                  updatedLabel,
                  style: TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: TextSize.font12(context),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 56,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButtons(
            buttonStyle: ButtonsStyle.activePrimaryButton,
            onTap: onRetry,
            title: 'Retry',
          ),
        ],
      ),
    );
  }
}
