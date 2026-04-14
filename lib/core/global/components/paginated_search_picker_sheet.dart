import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
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
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
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
                    items: widget.items,
                    isInitialLoading: widget.isInitialLoading,
                    isLoadingMore: widget.isLoadingMore,
                    hasMoreItems: widget.hasMoreItems,
                    onLoadMore: widget.onLoadMore,
                    emptyStateText: widget.emptyStateText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSearchChanged(String value) {
    setState(() {});
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
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index >= items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final item = items[index];
          return ListTile(
            title: Text(item),
            onTap: () => Navigator.of(context).pop(item),
          );
        },
      ),
    );
  }
}
