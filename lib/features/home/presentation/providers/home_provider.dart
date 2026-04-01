import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/data/repository/matches_repository.dart';

class HomeProvider extends BaseChangeNotifier {
  HomeScreenStates screenStates = HomeScreenStates.defaultState;
  HomeScreenStates loaderState = HomeScreenStates.defaultState;
  
  List<MatchProfile> premiumMatches = [];
  bool isLoadingPremiumMatches = false;
  String? premiumMatchesError;
  bool _hasLoadedPremiumMatches = false;

  Future<void> loadPremiumMatches({bool force = false}) async {
    if (_hasLoadedPremiumMatches && !force) return;
    isLoadingPremiumMatches = true;
    premiumMatchesError = null;
    notifyListeners();

    final response = await MatchesRepository.getMatches(
       GetMatchesQueryParams(
        page: 1,
        size: 1,
        type: 'premium_matches',
      ),
    );

    isLoadingPremiumMatches = false;

    final isSuccess = response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;

    if (isSuccess) {
      premiumMatches = response.data ?? [];
      _hasLoadedPremiumMatches = true;
      if (premiumMatches.isEmpty) {
        premiumMatchesError = 'No premium matches available at the moment.';
      } else {
        premiumMatchesError = null;
      }
    } else {
      premiumMatches.clear();
      premiumMatchesError = response.message ?? 'Unable to load premium matches.';
    }

    notifyListeners();
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
}

enum HomeScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}
