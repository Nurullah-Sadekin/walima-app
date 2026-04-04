import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/accepted_connection_response.dart';
import 'package:flutter_boilerplate/features/inbox/data/models/received_connection_response.dart';
import 'package:flutter_boilerplate/features/inbox/data/repository/inbox_repository.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class InboxProvider extends BaseChangeNotifier {
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

  List<SingleStringModel> sortByDataList = sortByListDataInserted
      .map((item) => item.copyWith())
      .toList();

  int currentPage = 1;
  int pageSize = 10;
  int totalItems = 0;

  String sortBy = 'id';
  String sortOrder = 'ASC';
  String searchQuery = '';
  String filterType = 'most_relevant';

  void updateViewState({bool? switcherValue}) {
    if (switcherValue != null) {
      this.switcherValue = switcherValue;
    }
    notifyListeners();
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
    if (!_isValidIndex(index, sortByDataList.length)) return;
    _setSingleSelection(
      sortByDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    notifyListeners();
  }

  void setSortBy(String sortField, {String order = 'ASC'}) {
    sortBy = sortField;
    sortOrder = order;
    currentPage = 1;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    currentPage = 1;
    notifyListeners();
  }

  void setFilterType(String filter) {
    filterType = filter;
    currentPage = 1;
    notifyListeners();
  }

  Future<void> applyFilters({
    String? sortByField,
    String? sortOrderValue,
    String? search,
    String? filter,
  }) async {
    if (sortByField != null) sortBy = sortByField;
    if (sortOrderValue != null) sortOrder = sortOrderValue;
    if (search != null) searchQuery = search;
    if (filter != null) filterType = filter;

    currentPage = 1;
    await fetchRequestedConnections(page: 1, size: pageSize);
  }

  Future<void> fetchRequestedConnections({
    int? page,
    int? size,
    String responseFormat = 'short',
  }) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      receivedConnectionsResponse = await InboxRepository.getRequestedConnections(
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
      } else {
        hasError = true;
        errorMessage =
            receivedConnectionsResponse?.message ?? 'Failed to load requests';
        receivedConnections = [];
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString();
      receivedConnections = [];
    }
    notifyListeners();
  }

  Future<void> loadMoreRequestedConnections() async {
    if (isLoading) return;

    currentPage++;
    final newResponse = await InboxRepository.getRequestedConnections(
      page: currentPage,
      size: pageSize,
      responseFormat: 'short',
      sortBy: sortBy,
      sortOrder: sortOrder,
      search: searchQuery,
      filter: filterType,
    );

    if (newResponse.code == 'SUCCESS' || newResponse.code == '1') {
      if (newResponse.response?.data != null) {
        receivedConnections?.addAll(newResponse.response!.data!);
      }
      notifyListeners();
    }
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
}
