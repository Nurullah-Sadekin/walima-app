import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/global/models/filter_model.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/connections/data/models/request/get_requested_connections_query_params.dart';
import 'package:walima_llc/features/connections/data/models/request/perform_connection_action_request_body.dart';
import 'package:walima_llc/features/connections/data/models/response/get_accepted_connection_response.dart'
    as accepted_models;
import 'package:walima_llc/features/connections/data/models/response/get_blocked_connection_response.dart'
    as blocked_models;
import 'package:walima_llc/features/connections/data/models/response/get_requested_connections_response.dart'
    as requested_models;
import 'package:walima_llc/features/connections/data/models/response/get_sent_connection_response.dart'
    as sent_models;
import 'package:walima_llc/features/connections/data/repository/connections_repository.dart';

class InboxProvider extends BaseChangeNotifier {
  InboxScreenStates screenStates = InboxScreenStates.defaultState;
  InboxScreenStates loaderState = InboxScreenStates.defaultState;

  bool? switcherValue = false;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;
  bool isUpdatingReceivedConnection = false;
  String? updatingReceivedConnectionId;
  String? receivedActionErrorMessage;

  List<requested_models.RequestedConnectionUser>? receivedConnections = [];
  requested_models.GetRequestedConnectionsResponse? receivedConnectionsResponse;

  List<accepted_models.Data>? acceptedConnections = [];
  accepted_models.GetAcceptedConnectionResponse? acceptedConnectionsResponse;
  bool isAcceptedLoading = false;
  bool isAcceptedHasError = false;
  String? acceptedErrorMessage;

  List<sent_models.Data>? sentConnections = [];
  sent_models.GetSentConnectionResponse? sentConnectionsResponse;
  bool isSentLoading = false;
  bool isSentHasError = false;
  bool isDeletingSentConnection = false;
  String? sentNotifyMessage;

  List<sent_models.Data>? deletedConnections = [];
  sent_models.GetSentConnectionResponse? deletedConnectionsResponse;
  bool isDeletedLoading = false;
  bool isDeletedHasError = false;
  String? deletedErrorMessage;

  List<blocked_models.BlockedConnectionData>? blockedConnections = [];
  blocked_models.GetBlockedConnectionResponse? blockedConnectionsResponse;
  bool isBlockedLoading = false;
  bool isBlockedHasError = false;
  String? blockedErrorMessage;

  List<Filter> receivedFilterList = buildInboxFilterDataList();
  List<Filter> sentFilterList = buildInboxFilterDataList();
  List<Filter> sortList = sortDataList;

  int? currentPage;
  int? pageSize;
  int? totalItems = 0;
  String? sortBy = 'id';
  String? sortOrder = 'ASC';
  String? searchQuery = '';
  String? receivedFilterType = InboxConnectionFilter.mostRelevant.apiValue;
  String? sentFilterType = InboxConnectionFilter.mostRelevant.apiValue;
  String? responseFormat = 'short';

  void switcherStatusUpdate({bool? switcherValue}) {
    if (switcherValue != null) {
      this.switcherValue = switcherValue;
    }
    updateViewState();
  }

  bool _isValidIndex(int index, int length) => index >= 0 && index < length;

  void _setSingleSelection<T>(
    List<T> list,
    int selectedIndex,
    void Function(T item, bool selected) applySelection,
  ) {
    for (var i = 0; i < list.length; i++) {
      applySelection(list[i], i == selectedIndex);
    }
  }

  void selectSortOrderIndex(int index) {
    if (!_isValidIndex(index, sortList.length)) return;
    _setSingleSelection(
      sortList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    sortOrder = sortList[index].value;
    notifyListeners();
  }

  void selectFilterTypeIndex(int index) {
    if (!_isValidIndex(index, receivedFilterList.length)) return;
    _setSingleSelection(
      receivedFilterList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    receivedFilterType = receivedFilterList[index].value;
    notifyListeners();
  }

  String? receivedFilterValueAt(int index) {
    if (!_isValidIndex(index, receivedFilterList.length)) return null;
    return receivedFilterList[index].value;
  }

  String? sentFilterValueAt(int index) {
    if (!_isValidIndex(index, sentFilterList.length)) return null;
    return sentFilterList[index].value;
  }

  String _filterHeaderTitle(String? activeFilter, List<Filter> filters) {
    final currentFilter = activeFilter?.trim();
    if (currentFilter == null || currentFilter.isEmpty) {
      return 'All Requests';
    }

    final matchedFilter = filters.cast<Filter?>().firstWhere(
          (item) => item?.value == currentFilter,
          orElse: () => null,
        );

    return matchedFilter?.label ?? 'All Requests';
  }

  String sentFilterHeaderTitle() {
    return _filterHeaderTitle(sentFilterType, sentFilterList);
  }

  String receivedFilterHeaderTitle() {
    return _filterHeaderTitle(receivedFilterType, receivedFilterList);
  }

  void clearReceivedFilterSelection({bool notify = true}) {
    for (final item in receivedFilterList) {
      item.isSelected = false;
    }
    if (notify) {
      notifyListeners();
    }
  }

  void clearSentFilterSelection({bool notify = true}) {
    for (final item in sentFilterList) {
      item.isSelected = false;
    }
    if (notify) {
      notifyListeners();
    }
  }

  void selectSortByIndex(int index) {
    selectSortOrderIndex(index);
  }

  GetRequestedConnectionsQueryParams _queryParams({
    int? page,
    int? size,
    String? responseFormat,
    String? sortBy,
    String? sortOrder,
    String? search,
    String? filter,
  }) {
    return GetRequestedConnectionsQueryParams(
      page: page,
      size: size,
      sortBy: sortBy,
      sortOrder: sortOrder,
      filter: filter,
      extraParams: {
        'responseFormat': responseFormat,
        'search': search,
      },
    );
  }

  Future<void> fetchRequestedConnections() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    updateViewState(
      screenStates: InboxScreenStates.loading,
      loadingState: InboxScreenStates.transparentLoading,
    );

    try {
      receivedConnectionsResponse =
          await ConnectionsRepository.getRequestedConnections(
        _queryParams(
          page: currentPage,
          size: pageSize,
          responseFormat: responseFormat,
          sortBy: sortBy,
          sortOrder: sortOrder,
          search: searchQuery,
          filter: receivedFilterType,
        ),
      );

      if (receivedConnectionsResponse?.code == 'SUCCESS') {
        receivedConnections = receivedConnectionsResponse?.response?.data ?? [];
        totalItems =
            receivedConnectionsResponse?.response?.pagination?.total?.toInt() ??
                receivedConnections?.length ??
                0;
        hasError = false;
        updateViewState(screenStates: InboxScreenStates.complete);
      } else {
        hasError = true;
        errorMessage =
            receivedConnectionsResponse?.message ?? 'Failed to load requests';
        receivedConnections = [];
        updateViewState(screenStates: InboxScreenStates.defaultState);
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      receivedConnections = [];
      updateViewState(screenStates: InboxScreenStates.defaultState);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> respondToRequestedConnection({
    required requested_models.RequestedConnectionUser connection,
    required String status,
  }) async {
    final connectionId = connection.connection?.id;
    if (connectionId == null || connectionId.isEmpty) {
      receivedActionErrorMessage = 'Connection id is missing';
      notifyListeners();
      return false;
    }

    isUpdatingReceivedConnection = true;
    updatingReceivedConnectionId = connectionId;
    receivedActionErrorMessage = null;
    notifyListeners();

    try {
      final response = await ConnectionsRepository.performConnectionAction(
        connectionId,
        PerformConnectionActionRequestBody(
          action: 'respond',
          status: status,
          message: connection.connection?.message,
          expiresAt: connection.connection?.expiresAt,
          isPriority: connection.connection?.isPriority,
        ),
      );

      if (response.isSuccess) {
        receivedConnections = (receivedConnections ?? [])
            .where((item) => item.connection?.id != connectionId)
            .toList();
        if (receivedConnectionsResponse?.response != null) {
          receivedConnectionsResponse!.response!.data = receivedConnections;
          final currentTotal =
              receivedConnectionsResponse?.response?.pagination?.total ?? 0;
          receivedConnectionsResponse!.response!.pagination?.total =
              currentTotal > 0 ? currentTotal - 1 : 0;
        }
        totalItems = (totalItems ?? 0) > 0 ? (totalItems ?? 0) - 1 : 0;

        if (status == 'accept') {
          await fetchAcceptedConnections();
        }

        isUpdatingReceivedConnection = false;
        updatingReceivedConnectionId = null;
        notifyListeners();
        return true;
      }

      receivedActionErrorMessage = response.message;
    } catch (e) {
      receivedActionErrorMessage = e.toString();
    }

    isUpdatingReceivedConnection = false;
    updatingReceivedConnectionId = null;
    notifyListeners();
    return false;
  }

  List<accepted_models.Data> get acceptedReceivedConnections =>
      _acceptedConnectionsByDirection('received');

  List<accepted_models.Data> get acceptedSentConnections =>
      _acceptedConnectionsByDirection('sent');

  List<accepted_models.Data> _acceptedConnectionsByDirection(String direction) {
    final items = acceptedConnections ?? const <accepted_models.Data>[];
    final normalizedDirection = direction.toLowerCase().trim();
    return items.where((item) {
      final itemDirection =
          item.connection?.direction?.toLowerCase().trim() ?? '';
      return itemDirection == normalizedDirection;
    }).toList();
  }

  Future<void> fetchAcceptedConnections({
    int page = 1,
    int size = 20,
    String responseFormat = 'short',
    String sortBy = 'id',
    String sortOrder = 'ASC',
    String search = '',
    String filter = 'all_accepted',
  }) async {
    isAcceptedLoading = true;
    isAcceptedHasError = false;
    acceptedErrorMessage = null;
    notifyListeners();

    try {
      acceptedConnectionsResponse =
          await ConnectionsRepository.getAcceptedConnections(
        _queryParams(
          page: page,
          size: size,
          responseFormat: responseFormat,
          sortBy: sortBy,
          sortOrder: sortOrder,
          search: search,
          filter: filter,
        ),
      );

      if (acceptedConnectionsResponse?.code == 'SUCCESS' ||
          acceptedConnectionsResponse?.code == '1') {
        acceptedConnections = acceptedConnectionsResponse?.response?.data ?? [];
        isAcceptedHasError = false;
      } else {
        isAcceptedHasError = true;
        acceptedErrorMessage = acceptedConnectionsResponse?.message ??
            'Failed to load accepted connections';
        acceptedConnections = [];
      }
    } catch (e) {
      isAcceptedHasError = true;
      acceptedErrorMessage = e.toString();
      acceptedConnections = [];
    }

    isAcceptedLoading = false;
    notifyListeners();
  }

  Future<void> fetchSentConnections({
    int page = 1,
    int size = 20,
    String responseFormat = 'short',
    String sortBy = 'id',
    String sortOrder = 'ASC',
    String search = '',
    String? filter,
  }) async {
    isSentLoading = true;
    isSentHasError = false;
    sentNotifyMessage = null;
    notifyListeners();

    try {
      sentConnectionsResponse = await ConnectionsRepository.getSentConnections(
        _queryParams(
          page: page,
          size: size,
          responseFormat: responseFormat,
          sortBy: sortBy,
          sortOrder: sortOrder,
          search: search,
          filter: filter ??
              sentFilterType ??
              InboxConnectionFilter.mostRelevant.apiValue,
        ),
      );

      if (sentConnectionsResponse?.code == 'SUCCESS' ||
          sentConnectionsResponse?.code == '1') {
        sentConnections = sentConnectionsResponse?.response?.data ?? [];
        isSentHasError = false;
      } else {
        isSentHasError = true;
        sentNotifyMessage = sentConnectionsResponse?.message ??
            'Failed to load sent connections';
        sentConnections = [];
      }
    } catch (e) {
      isSentHasError = true;
      sentNotifyMessage = e.toString();
      sentConnections = [];
    }

    isSentLoading = false;
    notifyListeners();
  }

  Future<void> applySentFilter(String filterValue) async {
    sentFilterType = filterValue;
    clearSentFilterSelection(notify: false);
    await fetchSentConnections(filter: filterValue);
    clearSentFilterSelection();
  }

  Future<void> applyReceivedFilter(String filterValue) async {
    receivedFilterType = filterValue;
    clearReceivedFilterSelection(notify: false);
    await fetchRequestedConnections();
    clearReceivedFilterSelection();
  }

  Future<bool> deleteSentConnection(String connectionId) async {
    isDeletingSentConnection = true;
    notifyListeners();

    try {
      final response =
          await ConnectionsRepository.deleteConnection(connectionId);
      if (response.isSuccess) {
        sentConnections = (sentConnections ?? [])
            .where((item) => item.connection?.id != connectionId)
            .toList();
        if (sentConnectionsResponse?.response != null) {
          sentConnectionsResponse!.response!.data = sentConnections;
        }
        isDeletingSentConnection = false;
        notifyListeners();
        return true;
      }

      sentNotifyMessage = response.message;
    } catch (e) {
      sentNotifyMessage = e.toString();
    }

    isDeletingSentConnection = false;
    notifyListeners();
    return false;
  }

  Future<String> sendSentConnectionReminder(String connectionId) async {
    sentNotifyMessage = null;
    notifyListeners();

    try {
      final response = await ConnectionsRepository.sendReminder(connectionId);
      final responseData = response.data;
      final backendMessage =
          responseData is Map && responseData['message'] is String
              ? responseData['message'] as String
              : response.message;

      if (response.isSuccess) {
        final items = sentConnections;
        if (items != null) {
          final index =
              items.indexWhere((item) => item.connection?.id == connectionId);
          if (index != -1) {
            final connection = items[index].connection;
            if (connection != null) {
              final currentCount = connection.reminderCount?.toInt() ?? 0;
              connection.reminderCount = currentCount + 1;
              connection.lastReminderAt = DateTime.now().toIso8601String();
            }
          }
        }
        sentNotifyMessage = backendMessage;
      } else {
        sentNotifyMessage = backendMessage;
      }
      notifyListeners();
      return backendMessage;
    } catch (e) {
      final message = e.toString();
      sentNotifyMessage = message;
      notifyListeners();
      return message;
    }
  }

  Future<void> fetchDeletedConnections({
    int page = 1,
    int size = 20,
    String responseFormat = 'short',
    String sortBy = 'id',
    String sortOrder = 'ASC',
    String search = '',
  }) async {
    isDeletedLoading = true;
    isDeletedHasError = false;
    deletedErrorMessage = null;
    notifyListeners();

    try {
      deletedConnectionsResponse =
          await ConnectionsRepository.getDeletedConnections(
        _queryParams(
          page: page,
          size: size,
          responseFormat: responseFormat,
          sortBy: sortBy,
          sortOrder: sortOrder,
          search: search,
        ),
      );

      if (deletedConnectionsResponse?.code == 'SUCCESS' ||
          deletedConnectionsResponse?.code == '1') {
        deletedConnections = deletedConnectionsResponse?.response?.data ?? [];
        isDeletedHasError = false;
      } else {
        isDeletedHasError = true;
        deletedErrorMessage = deletedConnectionsResponse?.message ??
            'Failed to load deleted connections';
        deletedConnections = [];
      }
    } catch (e) {
      isDeletedHasError = true;
      deletedErrorMessage = e.toString();
      deletedConnections = [];
    }

    isDeletedLoading = false;
    notifyListeners();
  }

  Future<void> fetchBlockedConnections({
    int page = 1,
    int size = 20,
    String responseFormat = 'short',
    String sortBy = 'id',
    String sortOrder = 'ASC',
    String search = '',
  }) async {
    isBlockedLoading = true;
    isBlockedHasError = false;
    blockedErrorMessage = null;
    notifyListeners();

    try {
      blockedConnectionsResponse =
          await ConnectionsRepository.getBlockedConnections(
        _queryParams(
          page: page,
          size: size,
          responseFormat: responseFormat,
          sortBy: sortBy,
          sortOrder: sortOrder,
          search: search,
        ),
      );

      if (blockedConnectionsResponse?.code == 'SUCCESS' ||
          blockedConnectionsResponse?.code == '1') {
        blockedConnections = blockedConnectionsResponse?.response?.data ?? [];
        isBlockedHasError = false;
      } else {
        isBlockedHasError = true;
        blockedErrorMessage = blockedConnectionsResponse?.message ??
            'Failed to load blocked connections';
        blockedConnections = [];
      }
    } catch (e) {
      isBlockedHasError = true;
      blockedErrorMessage = e.toString();
      blockedConnections = [];
    }

    isBlockedLoading = false;
    notifyListeners();
  }

  Future<void> loadPrimaryTab(int tabIndex) async {
    switch (tabIndex) {
      case 0:
        if ((receivedConnections?.isEmpty ?? true) && !isLoading) {
          await fetchRequestedConnections();
        }
        break;
      case 1:
        if ((acceptedConnections?.isEmpty ?? true) && !isAcceptedLoading) {
          await fetchAcceptedConnections();
        }
        break;
      case 2:
        if ((sentConnections?.isEmpty ?? true) && !isSentLoading) {
          await fetchSentConnections();
        }
        break;
      case 3:
        if ((blockedConnections?.isEmpty ?? true) && !isBlockedLoading) {
          await fetchBlockedConnections();
        }
        break;
    }
  }

  void clearReceivedConnections() {
    receivedConnections = [];
    receivedConnectionsResponse = null;
    currentPage = 1;
    totalItems = 0;
    isLoading = false;
    hasError = false;
    errorMessage = null;
    isUpdatingReceivedConnection = false;
    updatingReceivedConnectionId = null;
    receivedActionErrorMessage = null;
    sortBy = 'id';
    sortOrder = 'ASC';
    searchQuery = '';
    receivedFilterList = buildInboxFilterDataList();
    receivedFilterType = InboxConnectionFilter.mostRelevant.apiValue;
    responseFormat = 'short';
    notifyListeners();
  }

  void clearAcceptedConnections() {
    acceptedConnections = [];
    acceptedConnectionsResponse = null;
    isAcceptedLoading = false;
    isAcceptedHasError = false;
    acceptedErrorMessage = null;
    notifyListeners();
  }

  void clearSentConnections() {
    sentConnections = [];
    sentConnectionsResponse = null;
    isSentLoading = false;
    isSentHasError = false;
    isDeletingSentConnection = false;
    sentFilterList = buildInboxFilterDataList();
    sentFilterType = InboxConnectionFilter.mostRelevant.apiValue;
    sentNotifyMessage = null;
    notifyListeners();
  }

  void clearDeletedConnections() {
    deletedConnections = [];
    deletedConnectionsResponse = null;
    isDeletedLoading = false;
    isDeletedHasError = false;
    deletedErrorMessage = null;
    notifyListeners();
  }

  void clearBlockedConnections() {
    blockedConnections = [];
    blockedConnectionsResponse = null;
    isBlockedLoading = false;
    isBlockedHasError = false;
    blockedErrorMessage = null;
    notifyListeners();
  }

  void updateViewState({
    InboxScreenStates? screenStates,
    InboxScreenStates? loadingState,
  }) {
    if (screenStates != null) {
      this.screenStates = screenStates;
      loaderState = InboxScreenStates.defaultState;
    }
    if (loadingState != null) loaderState = loadingState;
    notifyListeners();
  }
}

enum InboxScreenStates {
  defaultState,
  loading,
  complete,
  transparentLoading,
}
