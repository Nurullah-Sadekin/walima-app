import 'dart:async';
import 'dart:collection';

import 'package:flutter_boilerplate/core/global/models/limit_info.dart';
import 'package:flutter_boilerplate/core/global/enums/enums.dart';
import 'package:flutter_boilerplate/core/global/repositorys/global_repository.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/login/data/models/get_me_response_body.dart'
    as me_response;

class GlobalProvider extends BaseChangeNotifier {
  GlobalProvider({
    GlobalRepository? repository,
  }) : _repository = repository ?? GlobalRepository();

  final GlobalRepository _repository;
  GlobalStatus status = GlobalStatus.initial;
  me_response.User? currentUser;
  String? appVersion;
  String? errorMessage;
  String deviceToken = '';
  String languageCode = 'en';
  String currentUserId = '';
  DateTime? lastQuotaSyncAt;
  Completer<bool>? _refreshCompleter;
  final Map<String, LimitInfo> _quotaByKey = <String, LimitInfo>{};

  UnmodifiableMapView<String, LimitInfo> get quotaByKey =>
      UnmodifiableMapView(_quotaByKey);

  List<LimitInfo> get quotas => _quotaByKey.values.toList()
    ..sort(
      (a, b) => (a.displayOrder ?? 9999).compareTo(
        b.displayOrder ?? 9999,
      ),
    );

  Future<void> initialize() async {
    if (appVersion != null && (currentUser != null || _quotaByKey.isNotEmpty)) {
      return;
    }

    await Future.wait([
      loadAppVersion(),
      hydrateSessionFromCache(),
    ]);
  }

  Future<void> loadAppVersion() async {
    _setStatus(GlobalStatus.loading);
    try {
      appVersion = await _repository.getAppVersion();
      _setStatus(GlobalStatus.success);
    } catch (error) {
      errorMessage = error.toString();
      _setStatus(GlobalStatus.failure);
    }
  }

  Future<void> hydrateSessionFromCache() async {
    try {
      final cachedMe = await _repository.getCachedMeSnapshot();
      if (cachedMe?.response?.user != null) {
        _applyMeResponse(cachedMe!, shouldNotify: false);
      } else {
        final cachedQuota = await _repository.getCachedQuotaSnapshot();
        if (cachedQuota.isNotEmpty) {
          _replaceQuota(cachedQuota, shouldNotify: false);
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> refreshCurrentUserAndQuota({bool silent = false}) async {
    final activeRefresh = _refreshCompleter;
    if (activeRefresh != null) {
      return activeRefresh.future;
    }

    _refreshCompleter = Completer<bool>();

    if (!silent) {
      _setStatus(GlobalStatus.loading);
    }

    try {
      final response = await _repository.fetchMe();
      if (response.code == 'SUCCESS' && response.response?.user != null) {
        _applyMeResponse(response);
        await _repository.cacheMeSnapshot(response);
        if (!silent) {
          _setStatus(GlobalStatus.success);
        } else {
          notifyListeners();
        }
        _refreshCompleter?.complete(true);
        return true;
      }

      errorMessage = response.message ?? 'Failed to fetch current user data.';
      if (!silent) {
        _setStatus(GlobalStatus.failure);
      }
      _refreshCompleter?.complete(false);
      return false;
    } catch (error) {
      errorMessage = error.toString();
      if (!silent) {
        _setStatus(GlobalStatus.failure);
      }
      _refreshCompleter?.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  LimitInfo? quotaFor(String key) => _quotaByKey[key];

  int remainingFor(String key) {
    final item = quotaFor(key);
    if (item == null) return 0;
    if (item.unlimited) return -1;
    return item.remaining ?? 0;
  }

  bool canUseFeature(String key, {int amount = 1}) {
    final item = quotaFor(key);
    if (item == null) return false;
    return item.canConsume(amount);
  }

  bool consumeFeature(String key, {int amount = 1}) {
    final item = quotaFor(key);
    if (item == null || !item.canConsume(amount)) {
      return false;
    }

    _quotaByKey[key] = item.consume(amount);
    notifyListeners();
    _cacheCurrentQuotaSnapshot();
    return true;
  }

  void rollbackFeature(String key, {int amount = 1}) {
    final item = quotaFor(key);
    if (item == null) return;
    _quotaByKey[key] = item.rollback(amount);
    notifyListeners();
    _cacheCurrentQuotaSnapshot();
  }

  void replaceFeatureQuota(LimitInfo info) {
    final key = info.key;
    if (key == null || key.isEmpty) return;
    _quotaByKey[key] = info;
    notifyListeners();
    _cacheCurrentQuotaSnapshot();
  }

  Future<void> clearSessionState() async {
    currentUser = null;
    currentUserId = '';
    lastQuotaSyncAt = null;
    _quotaByKey.clear();
    await _repository.clearCachedSessionState();
    notifyListeners();
  }

  Future<bool> refreshToken() async {
    _setStatus(GlobalStatus.loading);
    final refreshed = await GlobalRepository.refreshAccessToken();
    if (refreshed) {
      _setStatus(GlobalStatus.success);
      return true;
    }
    _setStatus(GlobalStatus.failure);
    return false;
  }

  void _setStatus(GlobalStatus next) {
    status = next;
    notifyListeners();
  }

  void _applyMeResponse(
    me_response.GetMeResponseBody response, {
    bool shouldNotify = true,
  }) {
    currentUser = response.response?.user;
    currentUserId = currentUser?.id ?? '';
    lastQuotaSyncAt = DateTime.now();
    _replaceQuota(
      _repository.extractLimits(response),
      shouldNotify: shouldNotify,
    );
  }

  void _replaceQuota(
    List<LimitInfo> items, {
    bool shouldNotify = true,
  }) {
    _quotaByKey
      ..clear()
      ..addEntries(
        items
            .where((item) => item.key != null && item.key!.isNotEmpty)
            .map((item) => MapEntry(item.key!, item)),
      );
    if (shouldNotify) {
      notifyListeners();
    }
  }

  void _cacheCurrentQuotaSnapshot() {
    final snapshot = me_response.GetMeResponseBody(
      code: 'SUCCESS',
      response: me_response.Response(
        user: currentUser != null
            ? me_response.User.fromJson(currentUser!.toJson())
            : null,
      ),
    );
    snapshot.response?.user?.premium?.features = quotas
        .map(
          (item) => me_response.Features(
            key: item.key,
            name: item.name,
            displayOrder: item.displayOrder,
            valueType: item.valueType,
            used: item.used,
            limit: item.limit,
            remaining: item.remaining,
            isUnlimited: item.isUnlimited,
            resetDate: item.resetDate,
            resetPeriod: item.resetPeriod,
            tierValue: item.tierValue,
          ),
        )
        .toList();
    _repository.cacheMeSnapshot(
      snapshot,
    );
    _repository.cacheQuotaSnapshot(quotas);
  }
}
