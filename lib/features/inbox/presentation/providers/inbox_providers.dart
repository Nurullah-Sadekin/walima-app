import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
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

  List<SingleStringModel> sortByDataList = sortByListDataInserted
      .map((item) => item.copyWith())
      .toList();

  // Pagination
  int currentPage = 1;
  int pageSize = 10;
  int totalItems = 0;

  void updateViewState({bool? switcherValue}) {
    if (switcherValue != null) {
      this.switcherValue = switcherValue;
    }
    notifyListeners();
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

  void sortBy(int index) {
    if (!_isValidIndex(index, sortByDataList.length)) return;
    _setSingleSelection(
      sortByDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    notifyListeners();
  }

  /// Fetch requested connections
  Future<void> fetchRequestedConnections({
    int page = 1,
    int size = 10,
    String responseFormat = 'short',
  }) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      receivedConnectionsResponse = await InboxRepository.getRequestedConnections(
        page: page,
        size: size,
        responseFormat: responseFormat,
      );

      if (receivedConnectionsResponse?.code == 'SUCCESS' ||
          receivedConnectionsResponse?.code == '1') {
        receivedConnections = receivedConnectionsResponse?.response?.data ?? [];

        // Extract pagination info if available
        if (receivedConnectionsResponse?.response?.pagination != null) {
          final pagination = receivedConnectionsResponse!.response!.pagination!;
          totalItems = pagination.total ?? 0;
          currentPage = pagination.page ?? page;
          pageSize = pagination.size ?? size;
        }

        isLoading = false;
        hasError = false;
      } else {
        hasError = true;
        errorMessage = receivedConnectionsResponse?.message ?? 'Failed to load requests';
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

  /// Load more requested connections (pagination)
  Future<void> loadMoreRequestedConnections() async {
    if (isLoading) return;

    currentPage++;
    final newResponse = await InboxRepository.getRequestedConnections(
      page: currentPage,
      size: pageSize,
      responseFormat: 'short',
    );

    if (newResponse.code == 'SUCCESS' || newResponse.code == '1') {
      if (newResponse.response?.data != null) {
        receivedConnections?.addAll(newResponse.response!.data!);
      }
      notifyListeners();
    }
  }

  /// Clear received connections
  void clearReceivedConnections() {
    receivedConnections = [];
    receivedConnectionsResponse = null;
    currentPage = 1;
    totalItems = 0;
    isLoading = false;
    hasError = false;
    errorMessage = null;
    notifyListeners();
  }
}

