import 'package:flutter/material.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/connectivity/connectivity_keys.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/preference_connect_card.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConnectMatches extends ConsumerStatefulWidget {
  const ConnectMatches({super.key});

  @override
  ConsumerState<ConnectMatches> createState() => _ConnectMatchesState();
}

class _ConnectMatchesState extends ConsumerState<ConnectMatches> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadConnectMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(recommendedPreferencesProvider);
    return TransparentLoading(
      isLoading: provider.isConnectMatchesLoading,
      child: Scaffold(
        body: GradientBackground(
          child: Column(
            children: [
              CustomBackAppBar(
                isBackButton: true,
                isTrailing: true,
                trailingText: 'Skip',
                onTrailingTap: () {
                  context.push(
                    Paths.upgradePackage,
                    extra: Routes.connectMatches,
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _body(),
              ),
              _bottomAction(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (provider.connectMatchesError != null &&
        provider.connectMatches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                provider.connectMatchesError!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: provider.loadConnectMatches,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.connectMatches.isEmpty) {
      return const Center(
        child: Text('No matches found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: provider.connectMatches.length,
      itemBuilder: (context, index) {
        final match = provider.connectMatches[index];
        final matchId = match.id ?? '';
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: PreferenceConnectCard(
            isSelected: provider.selectedConnectMatchIds.contains(matchId),
            onTap: () => provider.toggleConnectMatchSelection(matchId),
            imagePath: match.profilePhoto?.url ?? AppImages.demoProfile,
            name: match.displayName ?? 'Profile Name',
            age: _formatAge(match),
            height: _formatHeight(match),
            religion: _formatReligion(match),
            location: _formatLocation(match),
          ),
        );
      },
    );
  }

  Widget _bottomAction() {
    final hasSelection = provider.selectedConnectMatchIds.isNotEmpty;
    final isBusy = provider.isBulkSendingConnections;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PrimaryButtons(
        buttonStyle: hasSelection && !isBusy
            ? ButtonsStyle.activePrimaryButton
            : ButtonsStyle.disableButton,
        title: isBusy
            ? 'Sending...'
            : hasSelection
            ? 'Send Connection'
            : 'Select Matches',
        onTap: () async {
          if (!hasSelection || isBusy) return;

          final result = await provider.sendBulkConnectionRequests();
          if (result == null || !mounted) return;

          final dialogContext = rootNavigatorKey.currentContext;
          if (dialogContext == null) return;
          if (result.isSuccessDialog) {
            await DialogUtils.showSuccessDialog(
              context: dialogContext,
              title: 'Connection Sent',
              message: result.message,
              autoClose: false,
              onButtonPressed: () {
                if (Navigator.of(dialogContext, rootNavigator: true).canPop()) {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                }
                if (!mounted) return;
                context.push(
                  Paths.upgradePackage,
                  extra: Routes.connectMatches,
                );
              },
            );
            return;
          }

          await DialogUtils.showErrorDialog(
            context: dialogContext,
            title: 'Connection Failed',
            message: result.message,
            onButtonPressed: () {
              if (Navigator.of(dialogContext, rootNavigator: true).canPop()) {
                Navigator.of(dialogContext, rootNavigator: true).pop();
              }
              if (!mounted) return;
              context.push(
                Paths.upgradePackage,
                extra: Routes.connectMatches,
              );
            },
          );
        },
      ),
    );
  }

  String _formatAge(MatchProfile match) {
    final age = match.age;
    if (age == null) return 'Age not available';
    return '$age Years';
  }

  String _formatHeight(MatchProfile match) {
    final heightCm = match.height;
    if (heightCm == null) return 'Height not available';
    final totalInches = (heightCm.toDouble() / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet Feet $inches Inches';
  }

  String _formatReligion(MatchProfile match) {
    final parts = <String>[
      if ((match.religion ?? '').trim().isNotEmpty) match.religion!.trim(),
      if ((match.community ?? '').trim().isNotEmpty) match.community!.trim(),
    ];
    return parts.isEmpty ? 'Religion not available' : parts.join(', ');
  }

  String _formatLocation(MatchProfile match) {
    final location = match.location;
    final parts = <String>[
      if ((location?.city ?? '').trim().isNotEmpty) location!.city!.trim(),
      if ((location?.state ?? '').trim().isNotEmpty) location!.state!.trim(),
      if ((location?.country ?? '').trim().isNotEmpty) location!.country!.trim(),
    ];
    return parts.isEmpty ? 'Location not available' : parts.join(', ');
  }
}
