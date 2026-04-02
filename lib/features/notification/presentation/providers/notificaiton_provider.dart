import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/notification/data/notification_repository.dart';
import 'package:flutter_boilerplate/features/notification/data/notification_response.dart';

class NotificationProvider extends BaseChangeNotifier {
  NotificationScreenStates screenStates = NotificationScreenStates.defaultState;
  NotificationScreenStates loaderState = NotificationScreenStates.defaultState;
  final List<NotificationItem> notifications = [];

  NotificationStats? stats;
  NotificationPagination? pagination;
  String? errorMessage;
  bool isLoadingMore = false;
  int _currentPage = 1;
  static const int _limit = 10;
  String totalUnreadCount = '';

  Future<void> getNotificationCount() async {
    final response = await NotificationRepository.getUnReadNotificationCount();
    if(response.response?.data?.unreadCount != null) {
      totalUnreadCount = response.response!.data!.unreadCount.toString();
    }
    else {
      totalUnreadCount = '0';
    }
    updateViewState();
  }

  Future<void> getDetailList() async {
    if (screenStates == NotificationScreenStates.loading &&
        notifications.isEmpty) {
      return;
    }
    await getAllNotification();
  }

  bool get hasMore {
    final totalPages = pagination?.totalPages ?? 1;
    return _currentPage < totalPages;
  }

  void updateViewState({
    NotificationScreenStates? screenStates,
    NotificationScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = NotificationScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }

  Future<void> getAllNotification({bool isRefresh = false}) async {
    if (isRefresh) {
      updateViewState(
        loadingState: NotificationScreenStates.transparentLoading,
      );
    } else {
      updateViewState(screenStates: NotificationScreenStates.loading);
    }

    errorMessage = null;

    final response = await NotificationRepository.getNotifications(
      page: _currentPage,
      limit: _limit,
      filter: 'all_activities',
      type: 'connection',
    );

    final list = response.response?.data ?? <NotificationItem>[];
    final isSuccess = response.code == 'SUCCESS' ||
        (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300);

    if (isSuccess) {
      notifications
        ..clear()
        ..addAll(list);
      pagination = response.response?.pagination;
      stats = response.response?.stats;
      errorMessage = null;
      updateViewState(
        screenStates: NotificationScreenStates.complete,
        loadingState: NotificationScreenStates.defaultState,
      );
      return;
    }

    notifications.clear();
    pagination = null;
    stats = null;
    errorMessage = response.message ?? 'Failed to load notifications.';
    updateViewState(
      screenStates: NotificationScreenStates.complete,
      loadingState: NotificationScreenStates.defaultState,
    );
  }

  Future<void> loadMoreNotifications() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final response = await NotificationRepository.getNotifications(
      page: nextPage,
      limit: _limit,
      filter: 'all_activities',
      type: 'connection',
    );

    final isSuccess = response.code == 'SUCCESS' ||
        (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300);

    if (isSuccess) {
      final list = response.response?.data ?? <NotificationItem>[];
      notifications.addAll(list);
      _currentPage = nextPage;
      pagination = response.response?.pagination ?? pagination;
      stats = response.response?.stats ?? stats;
    }

    isLoadingMore = false;
    notifyListeners();
  }
}

enum NotificationScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}
