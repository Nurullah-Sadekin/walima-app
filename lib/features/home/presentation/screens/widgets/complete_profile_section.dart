import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/home/presentation/models/profile_strength_view_data.dart';
import 'package:walima_llc/features/profile/presentation/screen/profile_edit_section.dart';
import 'package:walima_llc/generated/l10n/app_localizations.dart';

enum ProfileStrengthNavigationKind {
  typedEditor,
  photos,
  contacts,
  genericEditor,
}

@immutable
class ProfileStrengthNavigationTarget {
  const ProfileStrengthNavigationTarget(this.kind, [this.section]);

  final ProfileStrengthNavigationKind kind;
  final ProfileEditSection? section;
}

ProfileStrengthNavigationTarget resolveProfileStrengthNavigationTarget(
  ProfileStrengthSection strengthSection,
) {
  final sectionKey = strengthSection.key.trim().toLowerCase();
  final fieldKey =
      strengthSection.firstIncompleteFieldKey?.trim().toLowerCase();

  switch (sectionKey) {
    case 'photos':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.photos,
      );
    case 'contact':
    case 'contacts':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.contacts,
      );
    case 'preferences':
      final section = switch (fieldKey) {
        'locationpreference' => ProfileEditSection.preferenceLocationDetails,
        'educationpreference' => ProfileEditSection.preferenceEducationCareer,
        'dietpreference' => ProfileEditSection.preferenceOtherDetails,
        _ => ProfileEditSection.preferenceBasicInfo,
      };
      return ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        section,
      );
    case 'basic_profile':
      return ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        fieldKey == 'bio'
            ? ProfileEditSection.aboutYourself
            : ProfileEditSection.basicDetails,
      );
    case 'family':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        ProfileEditSection.familyDetails,
      );
    case 'education':
    case 'profession':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        ProfileEditSection.educationCareer,
      );
    case 'appearance':
    case 'lifestyle':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        ProfileEditSection.basicDetails,
      );
    case 'religion':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        ProfileEditSection.religiousBackground,
      );
    case 'location':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        ProfileEditSection.location,
      );
    case 'interests':
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.typedEditor,
        ProfileEditSection.hobbiesInterests,
      );
    default:
      return const ProfileStrengthNavigationTarget(
        ProfileStrengthNavigationKind.genericEditor,
      );
  }
}

class CompleteProfileSection extends ConsumerStatefulWidget {
  const CompleteProfileSection({super.key});

  static const String _profileStrengthSource = 'completeProfile';

  @override
  ConsumerState<CompleteProfileSection> createState() =>
      _CompleteProfileSectionState();
}

class _CompleteProfileSectionState
    extends ConsumerState<CompleteProfileSection> {
  static const int _collapsedItemCount = 2;

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(homeProvider);
    final data = provider.profileStrength;

    if (data == null && provider.profileStrengthError == null) {
      return const _ProfileStrengthSkeleton();
    }

    if (data == null) {
      return _ProfileStrengthErrorCard(
        isRetrying: provider.isLoadingProfileStrength,
        onRetry: () =>
            ref.read(homeProvider).invalidateAndRefreshProfileStrength(),
      );
    }

    if (data.overallScore == 100) return const SizedBox.shrink();

    final viewData = ProfileStrengthViewData.fromDomain(data);
    final allSections = <ProfileStrengthSection>[
      ...viewData.incomplete,
      ...viewData.completed,
    ];
    final visibleSections = _isExpanded
        ? allSections
        : allSections.take(_collapsedItemCount).toList(growable: false);
    final visibleIncomplete = visibleSections
        .where((section) => !section.completed)
        .toList(growable: false);
    final visibleCompleted = visibleSections
        .where((section) => section.completed)
        .toList(growable: false);
    final hasMoreSections = allSections.length > _collapsedItemCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x080A0D14),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.isLoadingProfileStrength)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                ),
              _ProfileStrengthHeader(score: viewData.overallScore),
              if (provider.profileStrengthError != null)
                _StaleRefreshError(
                  isRetrying: provider.isLoadingProfileStrength,
                  onRetry: () => ref
                      .read(homeProvider)
                      .invalidateAndRefreshProfileStrength(),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                child: Column(
                  children: [
                    for (final section in visibleIncomplete)
                      _ProfileStrengthRow(
                        section: section,
                        onTap: () => _openSection(context, ref, section),
                      ),
                    if (visibleIncomplete.isNotEmpty &&
                        visibleCompleted.isNotEmpty)
                      const _CompletedDivider(),
                    for (final section in visibleCompleted)
                      _ProfileStrengthRow(
                        section: section,
                        onTap: () => _openSection(context, ref, section),
                      ),
                    if (hasMoreSections)
                      _ProfileStrengthExpansionControl(
                        isExpanded: _isExpanded,
                        onTap: () => setState(
                          () => _isExpanded = !_isExpanded,
                        ),
                      ),
                  ],
                ),
              ),
              if (viewData.tips.isNotEmpty) _TipsPanel(tips: viewData.tips),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _openSection(
    BuildContext context,
    WidgetRef ref,
    ProfileStrengthSection section,
  ) async {
    final sectionKey = section.key.trim().toLowerCase();
    final target = resolveProfileStrengthNavigationTarget(section);

    if (target.kind == ProfileStrengthNavigationKind.photos) {
      await context.pushNamed(
        Routes.photoUpload,
        extra: const <String, String>{
          'fromScreen': CompleteProfileSection._profileStrengthSource,
        },
      );
      if (!context.mounted) return;
      await ref.read(homeProvider).invalidateAndRefreshProfileStrength();
      return;
    }

    if (target.kind == ProfileStrengthNavigationKind.contacts) {
      final changed = await context.pushNamed(Routes.contactInformation);
      if (changed == true && context.mounted) {
        await ref.read(homeProvider).invalidateAndRefreshProfileStrength();
      }
      return;
    }

    if (target.kind == ProfileStrengthNavigationKind.genericEditor) {
      debugPrint(
        'Unknown profile strength section "$sectionKey"; '
        'opening the generic profile editor.',
      );
      await context.pushNamed(Routes.editProfile);
      return;
    }

    final changed = await context.pushNamed(
      Routes.profileSectionEdit,
      extra: target.section!.key,
    );
    if (changed == true && context.mounted) {
      await ref.read(homeProvider).invalidateAndRefreshProfileStrength();
    }
  }
}

class _ProfileStrengthHeader extends StatelessWidget {
  const _ProfileStrengthHeader({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.profileStrengthTitle,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font18(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _OverallScore(score: score),
        ],
      ),
    );
  }
}

class _OverallScore extends StatelessWidget {
  const _OverallScore({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visualScore = score.clamp(0, 100);
    final color = profileStrengthColor(visualScore);
    return Semantics(
      label: l10n.profileStrengthSemantics(score),
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.square(
              dimension: 48,
              child: CircularProgressIndicator(
                value: visualScore / 100,
                strokeWidth: 4,
                strokeCap: StrokeCap.round,
                color: color,
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
            Text(
              '$score',
              style: TextStyle(
                color: color,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStrengthRow extends StatelessWidget {
  const _ProfileStrengthRow({
    required this.section,
    required this.onTap,
  });

  final ProfileStrengthSection section;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = localizedProfileStrengthSectionLabel(l10n, section);
    final visualPercent = section.completionPercentage.clamp(0, 100);
    final color = profileStrengthColor(visualPercent);
    final status = section.completed
        ? l10n.profileStrengthCompletedStatus
        : l10n.profileStrengthIncompleteStatus;

    return Semantics(
      button: true,
      label: l10n.profileStrengthSectionSemantics(
        label,
        section.completionPercentage,
        status,
      ),
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                color: AppColors.textPrimaryLight,
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${section.completionPercentage}%',
                            style: TextStyle(
                              color: color,
                              fontSize: TextSize.font12(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: visualPercent / 100,
                          minHeight: 6,
                          color: color,
                          backgroundColor: const Color(0xFFF3F4F6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (section.completed)
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF10B981),
                    size: 20,
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.hintTextColor,
                    size: TextSize.font14(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStrengthExpansionControl extends StatelessWidget {
  const _ProfileStrengthExpansionControl({
    required this.isExpanded,
    required this.onTap,
  });

  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = isExpanded ? l10n.seeLess : l10n.seeMore;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton(
        key: const ValueKey<String>('profile-strength-expansion-control'),
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 4),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              size: TextSize.font18(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedDivider extends StatelessWidget {
  const _CompletedDivider();

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).profileStrengthCompleted;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFF3F4F6))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.hintTextColor,
                fontSize: TextSize.font12(context),
              ),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFF3F4F6))),
        ],
      ),
    );
  }
}

class _TipsPanel extends StatelessWidget {
  const _TipsPanel({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileStrengthTips,
            style: TextStyle(
              color: const Color(0xFFB45309),
              fontSize: TextSize.font12(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      color: const Color(0xFFD97706),
                      fontSize: TextSize.font12(context),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      localizedProfileStrengthTip(l10n, tip),
                      style: TextStyle(
                        color: const Color(0xFFD97706),
                        fontSize: TextSize.font12(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileStrengthErrorCard extends StatelessWidget {
  const _ProfileStrengthErrorCard({
    required this.isRetrying,
    required this.onRetry,
  });

  final bool isRetrying;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileStrengthTitle,
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font18(context),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profileStrengthUnavailable,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: isRetrying ? null : onRetry,
              icon: isRetrying
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaleRefreshError extends StatelessWidget {
  const _StaleRefreshError({
    required this.isRetrying,
    required this.onRetry,
  });

  final bool isRetrying;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: const Color(0xFFFFF1F2),
      child: InkWell(
        onTap: isRetrying ? null : onRetry,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFFE11D48),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.profileStrengthRefreshFailed,
                  style: TextStyle(
                    color: const Color(0xFFBE123C),
                    fontSize: TextSize.font12(context),
                  ),
                ),
              ),
              Text(
                l10n.retry,
                style: TextStyle(
                  color: const Color(0xFFBE123C),
                  fontSize: TextSize.font12(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStrengthSkeleton extends StatelessWidget {
  const _ProfileStrengthSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE5E7EB),
        highlightColor: const Color(0xFFF9FAFB),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const _SkeletonBox(width: 150, height: 22),
                  const Spacer(),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              for (var index = 0; index < 5; index++) ...[
                const Row(
                  children: [
                    _SkeletonBox(width: 130, height: 14),
                    Spacer(),
                    _SkeletonBox(width: 34, height: 14),
                  ],
                ),
                const SizedBox(height: 8),
                const _SkeletonBox(width: double.infinity, height: 6),
                if (index < 4) const SizedBox(height: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

Color profileStrengthColor(int score) {
  if (score >= 80) return const Color(0xFF10B981);
  if (score >= 50) return const Color(0xFFF59E0B);
  return const Color(0xFFF43F5E);
}

String localizedProfileStrengthSectionLabel(
  AppLocalizations l10n,
  ProfileStrengthSection section,
) {
  return switch (section.key.trim().toLowerCase()) {
    'preferences' => l10n.profileStrengthPreferences,
    'basic_profile' => l10n.profileStrengthBasicProfile,
    'photos' => l10n.profileStrengthPhotos,
    'family' => l10n.profileStrengthFamily,
    'education' => l10n.profileStrengthEducation,
    'profession' => l10n.profileStrengthProfession,
    'appearance' => l10n.profileStrengthAppearance,
    'religion' => l10n.profileStrengthReligion,
    'lifestyle' => l10n.profileStrengthLifestyle,
    'location' => l10n.profileStrengthLocation,
    'interests' => l10n.profileStrengthInterests,
    'contact' || 'contacts' => l10n.profileStrengthContact,
    _ => section.label,
  };
}

String localizedProfileStrengthTip(AppLocalizations l10n, String tip) {
  return switch (tip) {
    'Complete your Partner Preferences to improve match quality' =>
      l10n.profileStrengthTipPreferences,
    'Fill in your basic profile details to help others know you better' =>
      l10n.profileStrengthTipBasic,
    'Add your profile photo to improve visibility' =>
      l10n.profileStrengthTipPhotos,
    'Adding family details helps build trust with potential matches' =>
      l10n.profileStrengthTipFamily,
    'Share your education background to find compatible matches' =>
      l10n.profileStrengthTipEducation,
    'Adding your profession details improves match relevance' =>
      l10n.profileStrengthTipProfession,
    'Complete your appearance details for better matching accuracy' =>
      l10n.profileStrengthTipAppearance,
    'Specify your religious background for compatible matches' =>
      l10n.profileStrengthTipReligion,
    'Share your lifestyle choices to find like-minded matches' =>
      l10n.profileStrengthTipLifestyle,
    'Add your location to find matches nearby' =>
      l10n.profileStrengthTipLocation,
    'Share your interests and hobbies to find common ground' =>
      l10n.profileStrengthTipInterests,
    'Add contact information so matches can reach you' =>
      l10n.profileStrengthTipContact,
    _ => tip,
  };
}
