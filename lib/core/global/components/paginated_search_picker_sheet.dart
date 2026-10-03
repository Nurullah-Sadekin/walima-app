import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';

Future<String?> showPaginatedSearchPickerSheet({
  required BuildContext context,
  required String title,
  required String searchHintText,
  required List<String> items,
  required bool isInitialLoading,
  required bool isLoadingMore,
  required bool hasMoreItems,
  required Future<void> Function(String value) onSearchChanged,
  required Future<void> Function() onLoadMore,
  String initialQuery = '',
  Duration searchDebounce = const Duration(milliseconds: 350),
  String emptyStateText = 'No items found',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _PaginatedSearchPickerSheet(
        title: title,
        searchHintText: searchHintText,
        items: items,
        isInitialLoading: isInitialLoading,
        isLoadingMore: isLoadingMore,
        hasMoreItems: hasMoreItems,
        onSearchChanged: onSearchChanged,
        onLoadMore: onLoadMore,
        initialQuery: initialQuery,
        searchDebounce: searchDebounce,
        emptyStateText: emptyStateText,
      );
    },
  );
}

class _PaginatedSearchPickerSheet extends StatefulWidget {
  const _PaginatedSearchPickerSheet({
    required this.title,
    required this.searchHintText,
    required this.items,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.hasMoreItems,
    required this.onSearchChanged,
    required this.onLoadMore,
    required this.initialQuery,
    required this.searchDebounce,
    required this.emptyStateText,
  });

  final String title;
  final String searchHintText;
  final List<String> items;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMoreItems;
  final Future<void> Function(String value) onSearchChanged;
  final Future<void> Function() onLoadMore;
  final String initialQuery;
  final Duration searchDebounce;
  final String emptyStateText;

  @override
  State<_PaginatedSearchPickerSheet> createState() =>
      _PaginatedSearchPickerSheetState();
}

class _PaginatedSearchPickerSheetState
    extends State<_PaginatedSearchPickerSheet> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  static const double _collapsedSize = 0.65;
  static const double _expandedSize = 0.95;
  bool _wasKeyboardVisible = false;

  /// Cache of every distinct item the sheet has ever observed via
  /// [widget.items]. This lets local filtering keep working even after the
  /// parent provider clears its list to fetch a fresh API page.
  final List<String> _cachedItems = <String>[];
  final Set<String> _cachedItemKeys = <String>{};
  String _localQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _localQuery = widget.initialQuery;
    _mergeIntoCache(widget.items);
  }

  @override
  void didUpdateWidget(covariant _PaginatedSearchPickerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.items, oldWidget.items)) {
      _mergeIntoCache(widget.items);
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _mergeIntoCache(List<String> incoming) {
    for (final item in incoming) {
      final trimmed = item.trim();
      if (trimmed.isEmpty) continue;
      final key = trimmed.toLowerCase();
      if (_cachedItemKeys.add(key)) {
        _cachedItems.add(trimmed);
      }
    }
  }

  List<String> _resolveDisplayItems() {
    final query = _localQuery.trim().toLowerCase();
    if (query.isEmpty) {
      // No active query — show whatever the parent currently exposes so the
      // pagination/loading semantics match the API state exactly.
      return widget.items;
    }

    final filtered = <String>[];
    final seen = <String>{};
    for (final item in _cachedItems) {
      if (!item.toLowerCase().contains(query)) continue;
      final key = item.toLowerCase();
      if (seen.add(key)) {
        filtered.add(item);
      }
    }
    // Also include anything from widget.items that may not have been merged
    // yet (defensive — covers the rare race where build runs before
    // didUpdateWidget).
    for (final item in widget.items) {
      final trimmed = item.trim();
      if (trimmed.isEmpty) continue;
      if (!trimmed.toLowerCase().contains(query)) continue;
      final key = trimmed.toLowerCase();
      if (seen.add(key)) {
        filtered.add(trimmed);
      }
    }
    return filtered;
  }

  void _syncSheetToKeyboard(bool isKeyboardVisible) {
    if (isKeyboardVisible == _wasKeyboardVisible) return;
    _wasKeyboardVisible = isKeyboardVisible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_sheetController.isAttached) return;
      final target = isKeyboardVisible ? _expandedSize : _collapsedSize;
      if ((_sheetController.size - target).abs() < 0.01) return;
      _sheetController.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    _syncSheetToKeyboard(isKeyboardVisible);
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _collapsedSize,
      minChildSize: 0.5,
      maxChildSize: _expandedSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: keyboardHeight),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: TextSize.font18(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: widget.searchHintText,
                        hintStyle: TextStyle(
                          fontSize: TextSize.font16(context),
                          color: AppColors.textSecondaryLight,
                        ),
                        prefixIcon: Icon(Icons.search,color: AppColors.textSecondaryLight,size: TextSize.font22(context),),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                                icon:  Icon(Icons.close,color: AppColors.primary,size: TextSize.font22(context),),
                              ),
                        filled: true,
                        fillColor:  AppColors.greyLight.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _PaginatedSearchPickerList(
                      scrollController: scrollController,
                      items: _resolveDisplayItems(),
                      isInitialLoading: widget.isInitialLoading,
                      isLoadingMore: widget.isLoadingMore,
                      // Disable load-more while a local query is active so the
                      // user is not nudged to paginate past the locally
                      // filtered results — once the API returns matching
                      // items they get merged into the cache automatically.
                      hasMoreItems: _localQuery.trim().isEmpty
                          ? widget.hasMoreItems
                          : false,
                      onLoadMore: widget.onLoadMore,
                      emptyStateText: widget.emptyStateText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Apply the local filter immediately so the user sees instant feedback
      // from already-loaded items while the debounced API call is in flight.
      _localQuery = value;
    });
    _searchDebounce?.cancel();
    _searchDebounce = Timer(widget.searchDebounce, () {
      widget.onSearchChanged(value);
    });
  }
}

class _PaginatedSearchPickerList extends StatelessWidget {
  const _PaginatedSearchPickerList({
    required this.scrollController,
    required this.items,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.hasMoreItems,
    required this.onLoadMore,
    required this.emptyStateText,
  });

  final ScrollController scrollController;
  final List<String> items;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMoreItems;
  final Future<void> Function() onLoadMore;
  final String emptyStateText;

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyStateText,
          style: TextStyle(
            fontSize: TextSize.font14(context),
            color: AppColors.grey,
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!hasMoreItems || isLoadingMore) {
          return false;
        }

        final threshold = notification.metrics.maxScrollExtent - 120;
        if (notification.metrics.pixels >= threshold) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 10),
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        shrinkWrap: true, // Important: makes ListView take only needed space
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final item = items[index];
          return ListTile(
            title: Text(
              item,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color:Colors.black87,
                fontSize: TextSize.font16(context),
              ),
            ),
            onTap: () => Navigator.of(context).pop(item),
          );
        },
      ),
    );
  }
}
