import 'package:flutter_boilerplate/core/global/enums/global_status.dart';
import 'package:flutter_boilerplate/core/global/repositorys/global_repository.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/login/data/models/login_response.dart';

class GlobalProvider extends BaseChangeNotifier {
  GlobalProvider({
    GlobalRepository? repository,
  }) : _repository = repository ?? GlobalRepository();

  final GlobalRepository _repository;
  GlobalStatus status = GlobalStatus.initial;
  User? currentUser;
  String? appVersion;
  String? errorMessage;
  String deviceToken = '';
  String languageCode = 'en';
  String themeMode = 'light';
  String currentUserId = '';
  int remainingMassageQuota = 0;
  bool isMassageQuotaExceeded = false;
  
  Future<void> initialize() async {
    if (appVersion != null) {
      return;
    }
    
    await loadAppVersion();
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
}
