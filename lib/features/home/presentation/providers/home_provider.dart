import 'package:flutter/cupertino.dart';
import 'package:flutter_boilerplate/core/global/components/limit_over.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart' show ConnectionRequestType;
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/dialog_utils.dart';
import 'package:flutter_boilerplate/features/home/data/model/response/recent_visitors_response.dart';
import 'package:flutter_boilerplate/features/home/data/repository/home_repository.dart';
import 'package:flutter_boilerplate/features/matches/data/models/request/get_matches_query_params.dart';
import 'package:flutter_boilerplate/features/matches/data/models/response/get_matches_response.dart';
import 'package:flutter_boilerplate/features/matches/data/repository/matches_repository.dart';
import 'package:flutter_boilerplate/features/matches/domain/request/create_connection_request_body.dart';
import 'package:go_router/go_router.dart';

class HomeProvider extends BaseChangeNotifier {
  HomeProvider() {
    _loadInitialData();
  }
  HomeScreenStates screenStates = HomeScreenStates.defaultState;
  HomeScreenStates loaderState = HomeScreenStates.defaultState;
  MatchesRepository matchesRepository = MatchesRepository();

  void _loadInitialData() {
    Future.microtask(() async {
      await loadPremiumMatches();
      await loadRecentVisitors();
    });
  }

  final List<MatchProfile> premiumMatches = [];
  bool isLoadingPremiumMatches = false;
  String? premiumMatchesError;
  bool _hasLoadedPremiumMatches = false;

  final List<Data> recentVisitors = [];
  bool isLoadingRecentVisitors = false;
  String? recentVisitorsError;
  bool _hasLoadedRecentVisitors = false;

  Future<void> loadPremiumMatches({bool force = false}) async {
    if (_hasLoadedPremiumMatches && !force) return;
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

    isLoadingPremiumMatches = false;

    final isSuccess = response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;

    if (isSuccess) {
      premiumMatches
        ..clear()
        ..addAll(response.data ?? []);
      _hasLoadedPremiumMatches = true;
      premiumMatchesError = premiumMatches.isEmpty ? 'No premium matches available at the moment.' : null;
    } else {
      premiumMatches.clear();
      premiumMatchesError = response.message ?? 'Unable to load premium matches.';
    }

    notifyListeners();
  }

  Future<void> loadRecentVisitors({bool force = false}) async {
    if (_hasLoadedRecentVisitors && !force) return;
    isLoadingRecentVisitors = true;
    recentVisitorsError = null;
    notifyListeners();

    final response = await HomeRepository.getRecentVisitors();

    isLoadingRecentVisitors = false;

    final visitors = response.response?.data;
    if (visitors != null) {
      recentVisitors
        ..clear()
        ..addAll(visitors);
      _hasLoadedRecentVisitors = true;
      recentVisitorsError = visitors.isEmpty ? 'No recent visitors found yet.' : null;
    } else if (response.code == 'FAILED') {
      recentVisitors.clear();
      recentVisitorsError = response.message ?? 'Unable to load recent visitors.';
    } else {
      recentVisitors.clear();
      recentVisitorsError = 'No recent visitors available right now.';
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

  Future<void> connect(BuildContext context, String id, String userName, String connectionRequestType) async {
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
      await updateConnectionStatus(context, id ?? '');
    } else {
      if(response.message?.contains('daily_connect')??false){
        return await DialogUtils.show(
            context: context,
            child: LimitOver(
              onExtendPlan: (){
                context.pushNamed(Routes.upgradePackage);
                context.pop();
              },
            ),
        );
      }
      else{
        await DialogUtils.showErrorDialog(
          context: context,
          title: 'Connection Failed',
          buttonText: 'OK',
          message: response.message ?? 'Unable to send connection request. Please try again later.',
        );
      }
    }
    if (!context.mounted) return;
    updateViewState(screenStates: HomeScreenStates.complete);
  }

  Future<void> updateConnectionStatus(BuildContext context, String s) async {
      await loadPremiumMatches(force: true);
      await loadRecentVisitors(force: true);
  }
}

enum HomeScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}
