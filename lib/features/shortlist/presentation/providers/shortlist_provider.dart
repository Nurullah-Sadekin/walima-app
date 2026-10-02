import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/shortlist/data/models/shortlist_models.dart';
import 'package:walima_llc/features/shortlist/data/repository/shortlist_repository.dart';

/// Shortlist state shared by match cards, profile preview and the shortlist
/// screen. The backend is the source of truth; local state only changes after
/// a successful response.
class ShortlistProvider extends BaseChangeNotifier {
  static const _pageSize = 20;

  /// Known membership by member UUID (from list sync, status or mutations).
  final Map<String, bool> _membership = <String, bool>{};
  final Set<String> _pending = <String>{};
  bool _isSyncing = false;

  bool isShortlisted(String? memberId) =>
      memberId != null && _membership[memberId.trim()] == true;

  /// A request for this member is running; disable its button.
  bool isPending(String? memberId) =>
      memberId != null && _pending.contains(memberId.trim());

  // ---- List screen state ----
  final List<ShortlistedMember> members = <ShortlistedMember>[];
  ShortlistPagination? pagination;
  bool isLoadingList = false;
  bool isLoadingMore = false;
  String? listError;
  bool _hasLoadedList = false;
  int _listVersion = 0;

  bool get hasLoadedList => _hasLoadedList;
  bool get canLoadMore =>
      pagination?.hasNextPage == true && !isLoadingList && !isLoadingMore;

  /// Rebuilds membership from every list page so card buttons are accurate.
  /// The list excludes connected/hidden/deleted profiles, matching status.
  Future<void> syncMembership() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final ids = <String>{};
      var page = 1;
      while (true) {
        final response = await ShortlistRepository.getPage(
          page: page,
          size: ShortlistRepository.maxPageSize,
        );
        // Keep previous knowledge on failure rather than clearing buttons.
        if (!response.isSuccess || response.data == null) return;
        ids.addAll(response.data!.members.map((m) => m.id));
        if (!response.data!.pagination.hasNextPage) break;
        page = response.data!.pagination.page + 1;
      }
      _membership
        ..removeWhere((id, _) => !_pending.contains(id))
        ..addAll({for (final id in ids) id: true});
      notifyListeners();
    } finally {
      _isSyncing = false;
    }
  }

  /// Reads one member's membership (profile screen entry).
  Future<void> loadStatus(String? memberId) async {
    final id = memberId?.trim();
    if (id == null || id.isEmpty) return;
    final response = await ShortlistRepository.status(id);
    if (!response.isSuccess || response.data == null) return;
    if (_pending.contains(id)) return; // A mutation result will win.
    _membership[id] = response.data!.shortlisted;
    notifyListeners();
  }

  /// Adds or removes [memberId]. Returns an error message, or null on success.
  Future<String?> toggle(String? memberId) async {
    final id = memberId?.trim();
    if (id == null || id.isEmpty) return 'Profile id not found';
    if (_pending.contains(id)) return null;

    final wasShortlisted = isShortlisted(id);
    _pending.add(id);
    notifyListeners();

    final response = wasShortlisted
        ? await ShortlistRepository.remove(id)
        : await ShortlistRepository.add(id);

    _pending.remove(id);
    String? error;
    if (response.isSuccess && response.data != null) {
      _membership[id] = response.data!.shortlisted;
    } else {
      error = response.message;
      if (response.statusCode == 409) {
        // Connected members cannot be shortlisted; clear stale state.
        _membership[id] = false;
        await loadStatus(id);
      }
    }
    notifyListeners();

    // Rows shift after a mutation; reload from page 1 if the list is in use.
    if (_hasLoadedList) await loadFirstPage();
    return error;
  }

  Future<void> loadFirstPage() async {
    final version = ++_listVersion;
    isLoadingList = true;
    listError = null;
    notifyListeners();

    final response = await ShortlistRepository.getPage(size: _pageSize);
    if (version != _listVersion) return; // Superseded by a newer reload.

    if (response.isSuccess && response.data != null) {
      members
        ..clear()
        ..addAll(response.data!.members);
      pagination = response.data!.pagination;
      _hasLoadedList = true;
      for (final m in response.data!.members) {
        if (!_pending.contains(m.id)) _membership[m.id] = true;
      }
    } else {
      listError = response.message;
    }
    isLoadingList = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    final version = _listVersion;
    isLoadingMore = true;
    notifyListeners();

    final response = await ShortlistRepository.getPage(
      page: pagination!.page + 1,
      size: _pageSize,
    );
    if (version != _listVersion) {
      isLoadingMore = false; // A page-1 reload replaced this list.
      return;
    }

    if (response.isSuccess && response.data != null) {
      final seen = members.map((m) => m.id).toSet();
      members.addAll(response.data!.members.where((m) => seen.add(m.id)));
      pagination = response.data!.pagination;
      for (final m in response.data!.members) {
        if (!_pending.contains(m.id)) _membership[m.id] = true;
      }
    } else {
      listError = response.message;
    }
    isLoadingMore = false;
    notifyListeners();
  }

  /// After a connection is accepted the backend deletes shortlist entries in
  /// both directions; re-read instead of deleting locally.
  Future<void> onConnectionAccepted() async {
    await syncMembership();
    if (_hasLoadedList) await loadFirstPage();
  }
}
