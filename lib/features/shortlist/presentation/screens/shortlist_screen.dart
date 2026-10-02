import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/camel_case_utils.dart';
import 'package:walima_llc/core/utils/height_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/shortlist/data/models/shortlist_models.dart';
import 'package:walima_llc/features/shortlist/presentation/providers/shortlist_provider.dart';
import 'package:walima_llc/features/shortlist/presentation/shortlist_actions.dart';

/// Members the current user has shortlisted, newest first, paginated.
class ShortlistScreen extends ConsumerStatefulWidget {
  const ShortlistScreen({super.key});

  @override
  ConsumerState<ShortlistScreen> createState() => _ShortlistScreenState();
}

class _ShortlistScreenState extends ConsumerState<ShortlistScreen> {
  static const _accent = Color(0xFFE05271);

  @override
  void initState() {
    super.initState();
    // Always refetch on entry: the other member may have accepted a
    // connection meanwhile (no live push for shortlist changes).
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(shortlistProvider).loadFirstPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(shortlistProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(
        backgroundColor: Colors.white,
        backIconBackground: Colors.transparent,
        title: Text(
          'Shortlisted Profiles'.localized(context),
          style: const TextStyle(color: AppColors.textPrimaryLight),
        ),
      ),
      body: SafeArea(top: false, child: _body(provider)),
    );
  }

  Widget _body(ShortlistProvider provider) {
    if (provider.isLoadingList && !provider.hasLoadedList) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!provider.hasLoadedList && provider.listError != null) {
      return _message(
        icon: Icons.error_outline_rounded,
        text: provider.listError!,
        action: TextButton(
          onPressed: provider.loadFirstPage,
          child: Text('Retry'.localized(context)),
        ),
      );
    }

    final members = provider.members;
    final total = provider.pagination?.total ?? members.length;

    return RefreshIndicator(
      onRefresh: provider.loadFirstPage,
      color: AppColors.primary,
      child: members.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: _message(
                    icon: Icons.favorite_border_rounded,
                    text: 'No shortlisted profiles yet. Tap Shortlist on a profile to save it here.',
                  ),
                ),
              ],
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (n) {
                if (n.metrics.extentAfter < 300) provider.loadMore();
                return false;
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: members.length + 2,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text(
                      '$total ${'Profiles'.localized(context)}',
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: TextSize.font13(context),
                      ),
                    );
                  }
                  if (index == members.length + 1) {
                    return _footer(provider);
                  }
                  return _memberCard(provider, members[index - 1]);
                },
              ),
            ),
    );
  }

  Widget _footer(ShortlistProvider provider) {
    if (provider.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (provider.listError != null && provider.pagination?.hasNextPage == true) {
      return Center(
        child: TextButton(
          onPressed: provider.loadMore,
          child: Text('Load more'.localized(context)),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _memberCard(ShortlistProvider provider, ShortlistedMember member) {
    final details = [
      if (member.age != null) '${member.age} ${'Yr'.localized(context)}',
      if (member.height != null)
        HeightUtils.formatHeight(member.height!.toString()),
      if (member.profession != null)
        CamelCaseUtils.formatCamelCase(member.profession),
    ].where((s) => s.isNotEmpty).join('  ·  ');
    final fallbackAvatar = (member.gender ?? '').toLowerCase() == 'female'
        ? AppImages.womenAvatar
        : AppImages.manAvatar;

    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.greyLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          Routes.profilePreview,
          extra: {'userId': member.userReference ?? member.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              ClipOval(
                child: ShowImage(
                  imagePath: member.profilePictureUrl ?? fallbackAvatar,
                  errorImagePath: fallbackAvatar,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimaryLight,
                        fontSize: TextSize.font15(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (details.isNotEmpty)
                      Text(
                        details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: TextSize.font12(context),
                        ),
                      ),
                    if (member.locationText != null)
                      Text(
                        member.locationText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.hintTextColor,
                          fontSize: TextSize.font12(context),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from shortlist'.localized(context),
                onPressed: () =>
                    toggleShortlistWithFeedback(context, ref, member.id),
                icon: const Icon(Icons.favorite_rounded),
                color: _accent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _message({
    required IconData icon,
    required String text,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Icon(icon, size: 48, color: AppColors.hintTextColor),
            Text(
              text.localized(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
              ),
            ),
            if (action != null) action,
          ],
        ),
      ),
    );
  }
}
