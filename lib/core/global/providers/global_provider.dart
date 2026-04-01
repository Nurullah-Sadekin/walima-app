import 'package:flutter_boilerplate/core/global/enums/global_status.dart';
import 'package:flutter_boilerplate/core/global/repositorys/global_repository.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';

class GlobalProvider extends BaseChangeNotifier {
  GlobalProvider({
    GlobalRepository? repository,
  }) : _repository = repository ?? GlobalRepository();

  final GlobalRepository _repository;
  GlobalStatus status = GlobalStatus.initial;
  String? appVersion;
  String? errorMessage;

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
      errorMessage = error?.toString();
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
