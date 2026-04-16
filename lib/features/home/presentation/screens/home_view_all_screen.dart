import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/date_time_utils.dart';
import 'package:flutter_boilerplate/core/utils/height_utils.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/recent_visitors_response.dart';
import 'package:flutter_boilerplate/features/home/presentation/providers/home_provider.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/connections/presentation/widgets/view_contact_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/profile_comprehensive_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeViewAllType {
  premiumMatches,
  recentVisitors,
}

class HomeViewAllScreen extends ConsumerStatefulWidget {
  const HomeViewAllScreen({
    super.key,
    required this.type,
  });

  final HomeViewAllType type;

  @override
  ConsumerState<HomeViewAllScreen> createState() => _HomeViewAllScreenState();
}

class _HomeViewAllScreenState extends ConsumerState<HomeViewAllScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = ref.read(homeProvider);
      if (widget.type == HomeViewAllType.premiumMatches) {
        await provider.loadPremiumMatches();
      } else {
        await provider.loadRecentVisitors();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(homeProvider);
    final isPremiumPage = widget.type == HomeViewAllType.premiumMatches;
    final title = isPremiumPage ? 'Premium Matches' : 'Recent Visitors';
    final subtitle = isPremiumPage
        ? '${provider.premiumMatches.length} Profiles Found'
        : '${provider.recentVisitors.length} Profiles Found';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomBackAppBar(
        backgroundColor: Colors.white,
        isBackButton: true,
        backIconBackground: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.textPrimaryLight),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isPremiumPage
                  ? _premiumMatchesBody(provider)
                  : _recentVisitorsBody(provider),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _premiumMatchesBody(HomeProvider provider) {
    if (provider.isLoadingPremiumMatches) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.premiumMatchesError != null &&
        provider.premiumMatches.isEmpty) {
      return _emptyState(provider.premiumMatchesError!);
    }

    if (provider.premiumMatches.isEmpty) {
      return _emptyState('No premium matches available yet.');
    }

    return ListView.separated(
      itemCount: provider.premiumMatches.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildPremiumMatchCard(provider.premiumMatches[index]);
      },
    );
  }

  Widget _recentVisitorsBody(HomeProvider provider) {
    if (provider.isLoadingRecentVisitors) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.recentVisitorsError != null &&
        provider.recentVisitors.isEmpty) {
      return _emptyState(provider.recentVisitorsError!);
    }

    if (provider.recentVisitors.isEmpty) {
      return _emptyState('No recent visitors yet.');
    }

    return ListView.separated(
      itemCount: provider.recentVisitors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildRecentVisitorCard(provider.recentVisitors[index]);
      },
    );
  }

  Widget _emptyState(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: TextSize.font16(context),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPremiumMatchCard(MatchProfile match) {
    final location = _formatMatchLocation(match);
    final heightText = _formatMatchHeight(match.height);
    final activeStatus = _activeStatusText(match);
    final profession = match.profession ?? match.education;
    final imagePath = match.profilePhoto?.url;

    return ProfileComprehensiveCard(
      imagePath: imagePath ??
          (match.gender == 'female'
              ? AppImages.womenAvatar
              : AppImages.manAvatar),
      imageHeight: 300,
      isPremiumConnect: match.isPremium ?? true,
      isVerified: match.profilePhoto?.isVerified ?? false,
      name: match.displayName ?? 'Walima Member',
      age: '${match.age ?? 'Undefine'} Yr',
      height: HeightUtils.formatHeight(heightText),
      location: location,
      profession: profession,
      leftButtonColor: match.connection?.status == 'none'
          ? AppColors.greenButtonColor
          : AppColors.disableBackground,
      leftButtonTextColor: match.connection?.status == 'none'
          ? AppColors.white
          : AppColors.disableText,
      leftButtonIconColor: match.connection?.status == 'none'
          ? AppColors.white
          : AppColors.disableText,
      leftButtonBorderColor: match.connection?.status == 'none'
          ? AppColors.greenButtonColor
          : AppColors.disableBackground,
      viewOnAccept:
          match.profilePhoto?.visibilityStatus == 'visible' ? true : false,
      religion: match.religion,
      isOnline: match.isOnline ?? false,
      onTapRightButton: () async {
        await BottomSheetUtils.open(
          context: context,
          fullHeight: false,
          child: Consumer(
            builder: (context, ref, _) {
              return _contactPremiumBottomSheet(match);
            },
          ),
        );
      },
      onTapLeftButton: () {
        ref.read(homeProvider).connect(
              context,
              match.id ?? '',
              match.displayName ?? 'Unknown',
              ConnectionRequestType.match.apiValue,
            );
      },
      activeStatusText: activeStatus,
    );
  }

  Widget _buildRecentVisitorCard(Data visitor) {
    final location = _formatRecentVisitorLocation(visitor.location);
    final imageUrl = visitor.profilePhoto?.url?.toString();
    final imagePath = (imageUrl?.isNotEmpty ?? false)
        ? imageUrl!
        : (visitor.gender == 'female'
            ? AppImages.womenAvatar
            : AppImages.manAvatar);

    return ProfileComprehensiveCard(
      imagePath: imagePath,
      imageHeight: 300,
      isPremiumConnect: visitor.isPremium ?? false,
      isVerified: visitor.isVerified ?? false,
      name: visitor.displayName ?? 'Walima Member',
      age: '${visitor.age?.toInt() ?? 'Undefine'} Yr',
      height: HeightUtils.formatHeight(visitor.height.toString()),
      location: location,
      leftButtonColor: visitor.connection?.status == 'none'
          ? AppColors.greenButtonColor
          : AppColors.disableBackground,
      leftButtonTextColor: visitor.connection?.status == 'none'
          ? AppColors.white
          : AppColors.disableText,
      leftButtonIconColor: visitor.connection?.status == 'none'
          ? AppColors.white
          : AppColors.disableText,
      leftButtonBorderColor: visitor.connection?.status == 'none'
          ? AppColors.greenButtonColor
          : AppColors.disableBackground,
      viewOnAccept: visitor.profilePhoto?.visibilityStatus == 'visible',
      activeStatusText: _recentVisitorStatus(visitor),
      onTapRightButton: () async {
        await BottomSheetUtils.open(
          context: context,
          fullHeight: false,
          child: Consumer(
            builder: (context, ref, _) {
              return _contactVisitorBottomSheet(visitor);
            },
          ),
        );
      },
      onTapLeftButton: () {
        ref.read(homeProvider).connect(
              context,
              visitor.id ?? '',
              visitor.displayName ?? 'Unknown',
              ConnectionRequestType.match.apiValue,
            );
      },
    );
  }

  Widget _contactPremiumBottomSheet(MatchProfile match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ViewContactBottomSheet(
        userId: match.id ?? '',
        userName: match.displayName ?? 'Unknown',
        profileImagePath: (match.profilePhoto?.url?.isNotEmpty ?? false)
            ? match.profilePhoto!.url!
            : (match.gender == 'female'
            ? AppImages.womenAvatar
            : AppImages.manAvatar),
        description: match.connection?.message,
        isDescriptionVisible: false,
      ),
    );
  }

  Widget _contactVisitorBottomSheet(Data visitor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ViewContactBottomSheet(
        userId: visitor.id ?? '',
        userName: visitor.displayName ?? 'Unknown',
        profileImagePath: (visitor.profilePhoto?.url?.isNotEmpty ?? false)
            ? visitor.profilePhoto!.url!
            : (visitor.gender == 'female'
            ? AppImages.womenAvatar
            : AppImages.manAvatar),
        description: visitor.connection?.message,
        isDescriptionVisible: false,
      ),
    );
  }

  String? _formatMatchHeight(num? height) {
    if (height == null) return null;
    final doubleValue = height.toDouble();
    if (doubleValue % 1 == 0) {
      return doubleValue.toInt().toString();
    }
    return doubleValue.toStringAsFixed(1);
  }

  String? _formatMatchLocation(MatchProfile match) {
    final location = match.location;
    final parts = [location?.city, location?.state, location?.country]
        .where((value) => value != null && value.trim().isNotEmpty)
        .map((value) => value!.trim())
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String _activeStatusText(MatchProfile match) {
    if (match.isOnline == true) {
      return 'Online';
    }
    if (match.lastSeenAt != null && match.lastSeenAt!.isNotEmpty) {
      return DateTimeUtils.formatDate(DateTime.tryParse(match.lastSeenAt!));
    }
    return 'Offline';
  }

  String? _formatRecentVisitorLocation(Location? location) {
    final parts = [
      location?.city,
      location?.state?.toString(),
      location?.country,
    ]
        .where((value) => value != null && value.trim().isNotEmpty)
        .map((value) => value!.trim())
        .toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String _recentVisitorStatus(Data visitor) {
    return DateTimeUtils.formatDate(DateTime.tryParse(visitor.visitedAt ?? ''));
  }
}
