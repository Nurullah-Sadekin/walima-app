import 'dart:developer' as developer;

import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/features/matches/domain/enums/match_filter_type.dart';
import 'package:walima_llc/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/matches/data/repository/matches_repository.dart';
import 'package:walima_llc/features/matches/domain/enums/match_sort_by.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class MatchesProvider extends BaseChangeNotifier {
  MatchesProviderScreenStates screenStates =
      MatchesProviderScreenStates.defaultLoading;
  MatchesProviderScreenStates loaderState =
      MatchesProviderScreenStates.defaultLoading;

  List<SingleStringModel> sortByDataList = sortByListDataInserted;
  final List<MatchProfile> matches = [];
  final Map<int, Map<String, dynamic>> _tabFilters = {};

  GetMatchesResponse? matchesResponse;
  int selectedTabIndex = 0;
  MatchType moreMatchesType = MatchType.suggestedMembers;
  bool isLoadingMatches = false;
  bool isLoadingMoreMatches = false;
  String? matchesError;
  String? apiError;
  String? matchesTraceId;
  int _requestVersion = 0;

  int get matchesTotal => matchesResponse?.pagination?.total ?? matches.length;

  bool get canLoadMoreMatches =>
      matchesResponse?.pagination?.hasNextPage == true && !isLoadingMoreMatches;

  Future<void> setSelectedTab(int index) async {
    if (index < 0 || index == selectedTabIndex) return;
    selectedTabIndex = index;
    notifyListeners();
    await loadMatchesForSelectedTab(force: true);
  }

  Future<void> setMoreMatchesType(MatchType type) async {
    if (type == moreMatchesType) return;
    moreMatchesType = type;
    notifyListeners();
    await loadMatchesForSelectedTab(force: true);
  }

  bool _isValidIndex(int index, int length) {
    return index >= 0 && index < length;
  }

  void _setSingleSelection<T>(
    List<T> list,
    int selectedIndex,
    void Function(T item, bool selected) applySelection,
  ) {
    for (var i = 0; i < list.length; i++) {
      applySelection(list[i], i == selectedIndex);
    }
  }

  Future<void> sortBy(int index) async {
    if (!_isValidIndex(index, sortByDataList.length)) return;
    _setSingleSelection(
      sortByDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    notifyListeners();
    await loadMatchesForSelectedTab(force: true);
  }

  Future<void> applySearchFilters(Map<String, dynamic> filters) async {
    _tabFilters[0] = Map<String, dynamic>.from(filters);
    await loadMatchesForSelectedTab(force: true);
  }

  Future<void> applyNewFilters(Map<String, dynamic> filters) async {
    _tabFilters[1] = Map<String, dynamic>.from(filters);
    await loadMatchesForSelectedTab(force: true);
  }

  Future<void> applyMyMatchesFilters(Map<String, dynamic> filters) async {
    _tabFilters[3] = Map<String, dynamic>.from(filters);
    await loadMatchesForSelectedTab(force: true);
  }

  Future<void> applyMoreMatchesFilters(Map<String, dynamic> filters) async {
    _tabFilters[5] = {
      ...filters,
      if (filters['applied'] == true)
        'matchFilterType': MatchFilterType.twoWayMatches.apiValue,
    };
    await loadMatchesForSelectedTab(force: true);
  }

  MatchSortBy get selectedSortBy {
    final selected = sortByDataList.where((item) => item.isSelected);
    if (selected.isEmpty) return MatchSortBy.relevance;
    return MatchSortBy.fromLabel(selected.first.name);
  }

  String get selectedTabTitle {
    switch (selectedTabIndex) {
      case 0:
        return 'Search';
      case 1:
        return 'New';
      case 2:
        return 'Daily';
      case 3:
        return 'My Matches';
      case 4:
        return 'Near Me';
      case 5:
        return moreMatchesType.label;
      default:
        return 'Matches';
    }
  }

  Future<void> loadMatchesForSelectedTab({
    bool force = false,
    int page = 1,
  }) async {
    final requestedPage = force ? 1 : page;
    if (isLoadingMatches && !force) return;
    if (requestedPage > 1 && !canLoadMoreMatches) return;

    if (requestedPage == 1) {
      _requestVersion++;
      isLoadingMatches = true;
      isLoadingMoreMatches = false;
    } else {
      isLoadingMoreMatches = true;
    }
    final requestVersion = _requestVersion;
    matchesError = null;
    apiError = null;
    notifyListeners();

    final response = await MatchesRepository.getMatches(
      _buildQueryParams(selectedTabIndex, page: requestedPage),
    );

    if (requestVersion != _requestVersion) return;

    matchesResponse = response;
    matchesTraceId = response.traceId;
    if (requestedPage == 1) {
      isLoadingMatches = false;
    } else {
      isLoadingMoreMatches = false;
    }

    final isSuccess = response.isSuccess;

    if (isSuccess) {
      if (requestedPage == 1) matches.clear();
      _appendUniqueMatches(response.data ?? const <MatchProfile>[]);
      matchesError = matches.isEmpty ? 'No matches found.' : null;
      apiError = null;
    } else {
      if (requestedPage == 1) matches.clear();
      apiError = response.errors?.entries
          .map((e) => '${e.key}: ${e.value.join(', ')}')
          .join('\n');
      matchesError = response.message ?? 'Unable to load matches.';
      developer.log(
        'Matches load failed: $matchesError',
        name: 'MoreMatches',
        error: matchesTraceId == null ? null : 'traceId=$matchesTraceId',
      );
    }
    updateViewState(screenStates: MatchesProviderScreenStates.loadingComplete);
  }

  Future<void> loadMoreMatches() async {
    final nextPage = (matchesResponse?.pagination?.page ?? 1) + 1;
    await loadMatchesForSelectedTab(page: nextPage);
  }

  void _appendUniqueMatches(Iterable<MatchProfile> incoming) {
    final ids = matches.map((item) => item.id).whereType<String>().toSet();
    for (final item in incoming) {
      if (item.id == null || ids.add(item.id!)) matches.add(item);
    }
  }

  GetMatchesQueryParams _buildQueryParams(int tabIndex, {int page = 1}) {
    final tabFilters = _tabFilters[tabIndex] ?? const <String, dynamic>{};

    return GetMatchesQueryParams(
      type: _tabType(tabIndex),
      responseFormat: 'short',
      page: page,
      size: 20,
      sortBy: selectedSortBy.apiValue,
      maxDistance: tabIndex == 4 ? 50 : null,
      ageMin: tabFilters['ageMin'] as int?,
      ageMax: tabFilters['ageMax'] as int?,
      heightMin: tabFilters['heightMin'] as int?,
      heightMax: tabFilters['heightMax'] as int?,
      maritalStatus: tabFilters['maritalStatus'] as String?,
      religion: tabFilters['religion'] as String?,
      motherTongue: tabFilters['motherTongue'] as String?,
      countryLivingIn: (tabFilters['countryLivingIn'] as List?)?.cast<String>(),
      community: (tabFilters['community'] as List?)?.cast<String>(),
      haveChildren: tabFilters['haveChildren'] as String?,
      liveWithFamily: tabFilters['liveWithFamily'] as bool?,
      photoVisibility: tabFilters['photoVisibility'] as String?,
      doNotShow: (tabFilters['doNotShow'] as List?)?.cast<String>(),
      stateLivingIn: (tabFilters['stateLivingIn'] as List?)?.cast<String>(),
      countryGrewUpIn: tabFilters['countryGrewUpIn'] as String?,
      residencyStatus: tabFilters['residencyStatus'] as String?,
      qualification: (tabFilters['qualification'] as List?)?.cast<String>(),
      educationArea: (tabFilters['educationArea'] as List?)?.cast<String>(),
      workingWith: tabFilters['workingWith'] as String?,
      professionArea: tabFilters['professionArea'] as String?,
      annualIncome: tabFilters['annualIncome'] as String?,
      eatingHabits: tabFilters['eatingHabits'] as String?,
      matchFilterType: tabFilters['matchFilterType'] as String?,
      recentlyJoined: tabFilters['recentlyJoined'] as String?,
      activeMembers: tabFilters['activeMembers'] as String?,
      searchTitle: tabFilters['searchTitle'] as String?,
      extraParams: {
        if (tabFilters['profileId'] != null)
          'profileId': tabFilters['profileId'],
        if (tabFilters['includeFilteredProfiles'] != null)
          'includeFilteredProfiles': tabFilters['includeFilteredProfiles'],
        if (tabFilters['includeViewedProfiles'] != null)
          'includeViewedProfiles': tabFilters['includeViewedProfiles'],
      },
    );
  }

  String _tabType(int index) {
    switch (index) {
      case 0:
        return 'recommendations';
      case 1:
        return 'new';
      case 2:
        return 'today';
      case 3:
        return 'my_matches';
      case 4:
        return 'near_me';
      case 5:
        return moreMatchesType.apiValue;
      default:
        return 'recommendations';
    }
  }

  void updateViewState({
    MatchesProviderScreenStates? screenStates,
    MatchesProviderScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = MatchesProviderScreenStates.defaultLoading;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum MatchesProviderScreenStates {
  defaultLoading,
  loadingComplete,
  transParentLoading,
}
