import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:walima_llc/core/global/components/bottom_sheet.dart';
import 'package:walima_llc/core/global/components/limit_over.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/home/data/model/response/recent_visitors_response.dart';
import 'package:walima_llc/features/home/data/repository/home_repository.dart';
import 'package:walima_llc/features/home/domain/recent_visitors_entitlement.dart';
import 'package:walima_llc/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/matches/data/repository/matches_repository.dart';
import 'package:walima_llc/features/matches/domain/request/create_connection_request_body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeProvider extends BaseChangeNotifier {
  HomeProvider({
    Future<ProfileStrengthResponse> Function()? profileStrengthLoader,
  }) : _profileStrengthLoader =
            profileStrengthLoader ?? HomeRepository.getProfileStrength;

  final Future<ProfileStrengthResponse> Function() _profileStrengthLoader;

  HomeScreenStates screenStates = HomeScreenStates.defaultState;
  HomeScreenStates loaderState = HomeScreenStates.defaultState;
  MatchesRepository matchesRepository = MatchesRepository();

  final List<MatchProfile> premiumMatches = [];
  bool isLoadingPremiumMatches = false;
  String? premiumMatchesError;
  MatchesPagination? premiumMatchesPagination;
  String? premiumMatchesTraceId;
  bool _hasLoadedPremiumMatches = false;
  int _premiumMatchesRequestVersion = 0;

  final List<Data> recentVisitors = [];
  bool isLoadingRecentVisitors = false;
  String? recentVisitorsError;
  Pagination? recentVisitorsPagination;
  bool? hasRecentVisitorsFeature;
  String? recentVisitorsFeatureKey;
  String? recentVisitorsTraceId;
  bool isLoadingMoreRecentVisitors = false;
  bool _hasLoadedRecentVisitors = false;
  int _recentVisitorsRequestVersion = 0;

  final List<Data> recentlyViewed = [];
  bool isLoadingRecentlyViewed = false;
  String? recentlyViewedError;
  Pagination? recentlyViewedPagination;
  String? recentlyViewedTraceId;
  bool _hasLoadedRecentlyViewed = false;
  int _recentlyViewedRequestVersion = 0;

  int get premiumMatchesTotal =>
      premiumMatchesPagination?.total ?? premiumMatches.length;

  int get recentVisitorsTotal =>
      recentVisitorsPagination?.total ?? recentVisitors.length;

  int get recentlyViewedTotal =>
      recentlyViewedPagination?.total ?? recentlyViewed.length;

  bool get canLoadMoreRecentVisitors =>
      recentVisitorsPagination?.hasNextPage == true &&
      !isLoadingMoreRecentVisitors;

  bool isRecentVisitorLockedAt(int globalIndex) {
    return isRecentVisitorLocked(
      hasFeature: hasRecentVisitorsFeature,
      page: 1,
      size: recentVisitorsPagination?.size ?? 10,
      indexOnPage: globalIndex,
    );
  }

  ProfileStrengthData? profileStrength;
  bool isLoadingProfileStrength = false;
  String? profileStrengthError;
  String? profileStrengthTraceId;
  bool _hasLoadedProfileStrength = false;
  Future<void>? _activeProfileStrengthLoad;
  int _profileStrengthRequestVersion = 0;
  String? _profileStrengthUserId;

  void setAuthenticatedUser(String? userId) {
    final normalized = userId?.trim();
    final nextUserId =
        normalized == null || normalized.isEmpty ? null : normalized;
    if (_profileStrengthUserId == nextUserId) return;

    _profileStrengthUserId = nextUserId;
    _resetProfileStrengthState();
    _resetMoreMatchesState();
    notifyListeners();
  }

  Future<void> loadProfileStrength({bool force = false}) async {
    if (!force) {
      if (_hasLoadedProfileStrength) return;
      final active = _activeProfileStrengthLoad;
      if (active != null) return active;
    }

    final requestVersion = ++_profileStrengthRequestVersion;
    final request = _performProfileStrengthLoad(requestVersion);
    _activeProfileStrengthLoad = request;
    try {
      await request;
    } finally {
      if (identical(_activeProfileStrengthLoad, request)) {
        _activeProfileStrengthLoad = null;
      }
    }
  }

  Future<void> _performProfileStrengthLoad(int requestVersion) async {
    isLoadingProfileStrength = true;
    profileStrengthError = null;
    notifyListeners();

    final response = await _profileStrengthLoader();
    if (requestVersion != _profileStrengthRequestVersion) return;

    final data = response.response;
    final isMalformedSuccess =
        response.isSuccess && (data == null || data.sections.isEmpty);

    if (response.isSuccess && !isMalformedSuccess) {
      profileStrength = data;
      profileStrengthTraceId = response.traceId;
      _hasLoadedProfileStrength = true;
      _logOutOfRangeValues(data!);
    } else {
      profileStrengthError = isMalformedSuccess
          ? 'Profile strength details are unavailable.'
          : response.message.isNotEmpty
              ? response.message
              : 'Unable to load profile strength.';
      profileStrengthTraceId = response.traceId;
      developer.log(
        'Profile strength load failed: $profileStrengthError',
        name: 'ProfileStrength',
        error: response.traceId == null ? null : 'traceId=${response.traceId}',
      );
    }

    isLoadingProfileStrength = false;
    notifyListeners();
  }

  Future<void> invalidateAndRefreshProfileStrength() {
    _hasLoadedProfileStrength = false;
    return loadProfileStrength(force: true);
  }

  void clearProfileStrength() {
    _profileStrengthUserId = null;
    _resetProfileStrengthState();
    notifyListeners();
  }

  void _resetProfileStrengthState() {
    _profileStrengthRequestVersion++;
    _activeProfileStrengthLoad = null;
    profileStrength = null;
    profileStrengthError = null;
    profileStrengthTraceId = null;
    isLoadingProfileStrength = false;
    _hasLoadedProfileStrength = false;
  }

  void _logOutOfRangeValues(ProfileStrengthData data) {
    if (data.overallScore < 0 || data.overallScore > 100) {
      developer.log(
        'Out-of-range overall score: ${data.overallScore}',
        name: 'ProfileStrength',
      );
    }
    for (final section in data.sections) {
      if (section.completionPercentage < 0 ||
          section.completionPercentage > 100) {
        developer.log(
          'Out-of-range percentage for ${section.key}: '
          '${section.completionPercentage}',
          name: 'ProfileStrength',
        );
      }
    }
  }

  Future<void> loadPremiumMatches({bool force = false}) async {
    if (_hasLoadedPremiumMatches && !force) return;
    final requestVersion = ++_premiumMatchesRequestVersion;
    isLoadingPremiumMatches = true;
    premiumMatchesError = null;
    notifyListeners();

    final response = await MatchesRepository.getMatches(
      GetMatchesQueryParams(
        page: 1,
        size: 10,
        type: 'premium_matches',
      ),
    );

    if (requestVersion != _premiumMatchesRequestVersion) return;

    isLoadingPremiumMatches = false;

    final isSuccess = response.isSuccess;

    if (isSuccess) {
      premiumMatches
        ..clear()
        ..addAll(response.data ?? []);
      _hasLoadedPremiumMatches = true;
      premiumMatchesPagination = response.pagination;
      premiumMatchesTraceId = response.traceId;
      premiumMatchesError = premiumMatches.isEmpty
          ? 'No premium matches available at the moment.'
          : null;
    } else {
      premiumMatches.clear();
      premiumMatchesPagination = null;
      premiumMatchesTraceId = response.traceId;
      premiumMatchesError =
          response.message ?? 'Unable to load premium matches.';
      _logApiFailure(
        'Premium matches',
        premiumMatchesError,
        premiumMatchesTraceId,
      );
    }

    notifyListeners();
  }

  Future<void> loadRecentVisitors({
    bool force = false,
    int page = 1,
  }) async {
    final requestedPage = force ? 1 : page;
    if (_hasLoadedRecentVisitors && requestedPage == 1 && !force) return;
    if (requestedPage > 1 && !canLoadMoreRecentVisitors) return;

    if (requestedPage == 1) {
      _recentVisitorsRequestVersion++;
      isLoadingRecentVisitors = true;
      isLoadingMoreRecentVisitors = false;
    } else {
      isLoadingMoreRecentVisitors = true;
    }
    final requestVersion = _recentVisitorsRequestVersion;
    recentVisitorsError = null;
    notifyListeners();

    final response = await HomeRepository.getRecentVisitors(
      page: requestedPage,
      size: recentVisitorsPagination?.size ?? 10,
    );

    if (requestVersion != _recentVisitorsRequestVersion) return;

    if (requestedPage == 1) {
      isLoadingRecentVisitors = false;
    } else {
      isLoadingMoreRecentVisitors = false;
    }

    final payload = response.response;
    final visitors = payload?.data;
    if (response.isSuccess && payload != null && visitors != null) {
      if (requestedPage == 1) {
        recentVisitors.clear();
      }
      _appendUniqueById(recentVisitors, visitors);
      recentVisitorsPagination = payload.pagination;
      hasRecentVisitorsFeature = payload.hasRecentVisitorsFeature;
      recentVisitorsFeatureKey = payload.recentVisitorsFeatureKey;
      recentVisitorsTraceId = response.traceId;
      _hasLoadedRecentVisitors = true;
      recentVisitorsError =
          recentVisitors.isEmpty ? 'No recent visitors found yet.' : null;
    } else {
      if (requestedPage == 1) {
        recentVisitors.clear();
        recentVisitorsPagination = null;
      }
      recentVisitorsTraceId = response.traceId;
      recentVisitorsError =
          response.message ?? 'Unable to load recent visitors.';
      _logApiFailure(
        'Recent visitors',
        recentVisitorsError,
        recentVisitorsTraceId,
      );
    }

    notifyListeners();
  }

  Future<void> loadMoreRecentVisitors() async {
    final nextPage = (recentVisitorsPagination?.page ?? 1) + 1;
    await loadRecentVisitors(page: nextPage);
  }

  Future<void> loadRecentlyViewed({bool force = false}) async {
    if (_hasLoadedRecentlyViewed && !force) return;
    final requestVersion = ++_recentlyViewedRequestVersion;
    isLoadingRecentlyViewed = true;
    recentlyViewedError = null;
    notifyListeners();

    final response = await HomeRepository.getRecentlyViewed();
    if (requestVersion != _recentlyViewedRequestVersion) return;
    isLoadingRecentlyViewed = false;
    final payload = response.response;

    if (response.isSuccess && payload != null) {
      recentlyViewed
        ..clear()
        ..addAll(payload.data ?? const <Data>[]);
      recentlyViewedPagination = payload.pagination;
      recentlyViewedTraceId = response.traceId;
      _hasLoadedRecentlyViewed = true;
      recentlyViewedError =
          recentlyViewed.isEmpty ? 'No recently viewed profiles yet.' : null;
    } else {
      recentlyViewed.clear();
      recentlyViewedPagination = null;
      recentlyViewedTraceId = response.traceId;
      recentlyViewedError =
          response.message ?? 'Unable to load recently viewed profiles.';
      _logApiFailure(
        'Recently viewed',
        recentlyViewedError,
        recentlyViewedTraceId,
      );
    }

    notifyListeners();
  }

  Future<void> ensureHomeDataLoaded() async {
    if (!isLoadingProfileStrength && !_hasLoadedProfileStrength) {
      await loadProfileStrength(force: true);
    }

    if (!isLoadingPremiumMatches &&
        (!_hasLoadedPremiumMatches || premiumMatches.isEmpty)) {
      await loadPremiumMatches(force: true);
    }

    if (!isLoadingRecentVisitors &&
        (!_hasLoadedRecentVisitors || recentVisitors.isEmpty)) {
      await loadRecentVisitors(force: true);
    }

    if (!isLoadingRecentlyViewed &&
        (!_hasLoadedRecentlyViewed || recentlyViewed.isEmpty)) {
      await loadRecentlyViewed(force: true);
    }
  }

  void updateViewState({
    HomeScreenStates? screenStates,
    HomeScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = HomeScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }

  Future<void> connect(
    BuildContext context,
    String id,
    String userName,
    String connectionRequestType,
  ) async {
    updateViewState(screenStates: HomeScreenStates.transparentLoading);
    final body = CreateConnectionRequestBody(
      receiverId: id,
      requestType: connectionRequestType,
      message: 'Hi $userName, I would like to connect with you!',
      markAsDefaultConnectionMessage: true,
      expiresAt: DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      isPriority: false,
    );
    final response = await matchesRepository.createConnectionRequest(body);
    if (!context.mounted) return;
    if (response.isSuccess) {
      DialogUtils.showSuccessDialog(
        context: context,
        message: response.message ?? 'Connection request sent successfully.',
        autoClose: false,
      );
      await updateConnectionStatus(context, id);
    } else {
      if (response.message?.contains('daily_connect') ?? false) {
        await BottomSheetUtils.open(
          context: context,
          fullHeight: false,
          child: Consumer(
            builder: (context, ref, _) {
              return LimitOver(
                onExtendPlan: () {
                  context.pop();
                  context.pushNamed(Routes.upgradePackage);
                },
              );
            },
          ),
        );
      } else {
        await DialogUtils.showErrorDialog(
          context: context,
          title: 'Connection Failed',
          buttonText: 'OK',
          message: response.message ??
              'Unable to send connection request. Please try again later.',
        );
      }
    }
    if (!context.mounted) return;
    updateViewState(screenStates: HomeScreenStates.complete);
  }

  Future<void> updateConnectionStatus(BuildContext context, String s) async {
    await loadPremiumMatches(force: true);
    await loadRecentVisitors(force: true);
    await loadRecentlyViewed(force: true);
  }

  void _appendUniqueById(List<Data> target, Iterable<Data> incoming) {
    final existingIds =
        target.map((item) => item.id).whereType<String>().toSet();
    for (final item in incoming) {
      if (item.id == null || existingIds.add(item.id!)) {
        target.add(item);
      }
    }
  }

  void _logApiFailure(String area, String? message, String? traceId) {
    developer.log(
      '$area load failed: ${message ?? 'Unknown error'}',
      name: 'MoreMatches',
      error: traceId == null ? null : 'traceId=$traceId',
    );
  }

  void _resetMoreMatchesState() {
    _premiumMatchesRequestVersion++;
    _recentVisitorsRequestVersion++;
    _recentlyViewedRequestVersion++;

    premiumMatches.clear();
    premiumMatchesError = null;
    premiumMatchesPagination = null;
    premiumMatchesTraceId = null;
    isLoadingPremiumMatches = false;
    _hasLoadedPremiumMatches = false;

    recentVisitors.clear();
    recentVisitorsError = null;
    recentVisitorsPagination = null;
    hasRecentVisitorsFeature = null;
    recentVisitorsFeatureKey = null;
    recentVisitorsTraceId = null;
    isLoadingRecentVisitors = false;
    isLoadingMoreRecentVisitors = false;
    _hasLoadedRecentVisitors = false;

    recentlyViewed.clear();
    recentlyViewedError = null;
    recentlyViewedPagination = null;
    recentlyViewedTraceId = null;
    isLoadingRecentlyViewed = false;
    _hasLoadedRecentlyViewed = false;
  }
}

enum HomeScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}
