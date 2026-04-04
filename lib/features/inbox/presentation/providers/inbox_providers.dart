import 'package:flutter_boilerplate/core/global/models/filter_model.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/accepted_connection_response.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/received_connection_response.dart';
import 'package:flutter_boilerplate/features/inbox/data/repository/inbox_repository.dart';

class InboxProvider extends BaseChangeNotifier {
  InboxScreenStates screenStates = InboxScreenStates.defaultState;
  InboxScreenStates loaderState = InboxScreenStates.defaultState;

  bool? switcherValue = false;
  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  List<Data>? receivedConnections = [];
  ReceivedConnectionResponse? receivedConnectionsResponse;

  List<AcceptedData>? acceptedConnections = [];
  AcceptedConnectionResponse? acceptedConnectionsResponse;
  bool isAcceptedLoading = false;
  bool isAcceptedHasError = false;
  String? acceptedErrorMessage;

  List<Filter> filterList = filterDataList;
  List<Filter> sortList = sortDataList;


  // filter item
  int? currentPage;
  int? pageSize;
  int? totalItems = 0;
  String? sortBy;
  String? sortOrder;
  String? searchQuery;
  String? filterType;

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

  void selectSortByIndex(int index) {
    if (!_isValidIndex(index, filterList.length)) return;
    _setSingleSelection(
      filterList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    notifyListeners();
  }

  Future<void> fetchRequestedConnections({
    int? page,
    int? size,
    String responseFormat = 'short',
  }) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    updateViewState(
      screenStates: InboxScreenStates.loading,
      loadingState: InboxScreenStates.transparentLoading,
    );

    try {
      receivedConnectionsResponse =
          await InboxRepository.getRequestedConnections(
        page: page ?? currentPage,
        size: size ?? pageSize,
        responseFormat: responseFormat,
        sortBy: sortBy,
        sortOrder: sortOrder,
        search: searchQuery,
        filter: filterType,
      );

      if (receivedConnectionsResponse?.code == 'SUCCESS' ||
          receivedConnectionsResponse?.code == '1') {
        receivedConnections = receivedConnectionsResponse?.response?.data ?? [];

        final pagination = receivedConnectionsResponse?.response?.pagination;
        if (pagination != null) {
          totalItems = pagination.total ?? 0;
          currentPage = pagination.page ?? (page ?? currentPage);
          pageSize = pagination.size ?? (size ?? pageSize);
        }

        isLoading = false;
        hasError = false;
        updateViewState(screenStates: InboxScreenStates.complete);
      } else {
        hasError = true;
        errorMessage =
            receivedConnectionsResponse?.message ?? 'Failed to load requests';
        receivedConnections = [];
        isLoading = false;
        updateViewState(screenStates: InboxScreenStates.defaultState);
      }
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      receivedConnections = [];
      updateViewState(screenStates: InboxScreenStates.defaultState);
    }
    notifyListeners();
  }

  List<AcceptedData> get acceptedReceivedConnections =>
      _acceptedConnectionsByDirection('received');

  List<AcceptedData> get acceptedSentConnections =>
      _acceptedConnectionsByDirection('sent');

  List<AcceptedData> _acceptedConnectionsByDirection(String direction) {
    final items = acceptedConnections ?? const <AcceptedData>[];
    final normalizedDirection = direction.toLowerCase().trim();
    return items.where((item) {
      final itemDirection =
          item.connection?.direction?.toLowerCase().trim() ?? '';
      return itemDirection == normalizedDirection;
    }).toList();
  }

  Future<void> fetchAcceptedConnections({
    int page = 1,
    int size = 10,
    String responseFormat = 'short',
  }) async {
    isAcceptedLoading = true;
    isAcceptedHasError = false;
    acceptedErrorMessage = null;
    notifyListeners();

    try {
      acceptedConnectionsResponse =
          await InboxRepository.getAcceptedConnections(
        page: page,
        size: size,
        responseFormat: responseFormat,
      );

      if (acceptedConnectionsResponse?.code == 'SUCCESS' ||
          acceptedConnectionsResponse?.code == '1') {
        acceptedConnections = acceptedConnectionsResponse?.response?.data ?? [];
        isAcceptedLoading = false;
        isAcceptedHasError = false;
      } else {
        isAcceptedHasError = true;
        acceptedErrorMessage = acceptedConnectionsResponse?.message ??
            'Failed to load accepted connections';
        acceptedConnections = [];
        isAcceptedLoading = false;
      }
    } catch (e) {
      isAcceptedLoading = false;
      isAcceptedHasError = true;
      acceptedErrorMessage = e.toString();
      acceptedConnections = [];
    }
    notifyListeners();
  }

  void clearReceivedConnections() {
    receivedConnections = [];
    receivedConnectionsResponse = null;
    currentPage = 1;
    totalItems = 0;
    isLoading = false;
    hasError = false;
    errorMessage = null;
    sortBy = 'id';
    sortOrder = 'ASC';
    searchQuery = '';
    filterType = 'most_relevant';
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
