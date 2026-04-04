// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class BottomSheetUtils {
  /// Shows a bottom sheet with a list of items for single selection (Dropdown style)
  static Future<dynamic> singleItemSelectBottomSheet({
    required BuildContext context,
    required List items,
    required String header,
    dynamic selectedValue,
    String? hintText,
  }) async {
    // Create a local copy of selected value to manage state
    dynamic tempSelectedValue = selectedValue;

    // Calculate dynamic height based on number of items
    double itemHeight = 70.0; // Approximate height per item
    double headerHeight = 60.0; // Height of header section
    double maxHeight = MediaQuery.of(context).size.height * 0.9; // Max 60% of screen
    double calculatedHeight = (items.length * itemHeight) + headerHeight;
    double bottomSheetHeight = calculatedHeight > maxHeight ? maxHeight : calculatedHeight;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: bottomSheetHeight, // Dynamic height based on content
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Important: minimizes height
                  children: [
                    // Header section with drag handle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    _buildHeader(context, header),
                    // Items list - no Expanded, use Flexible with fit
                    Flexible(
                      child: _buildItemsList(
                        context,
                        items,
                        tempSelectedValue,
                        (dynamic newValue) {
                          setState(() {
                            tempSelectedValue = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20), // Add some spacing at the bottom
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  static Future<dynamic> open({
    required BuildContext context,
    required Widget child,
    bool? fullHeight,
    bool showHeader = true,
  }) async {
    final maxHeightFactor = fullHeight == true ? 0.88 : 0.5;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Always true to allow custom sizing
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Takes minimum height needed
                children: [
                  if (showHeader) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: ShowImage(
                              imagePath: AppImages.cancelSvgIcon,
                              width: TextSize.font20(context),
                              height: TextSize.font20(context),
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height *
                          maxHeightFactor -
                          (showHeader ? 72 : 0),
                    ),
                    child: SingleChildScrollView(
                      child: _wrapChildForReturn(context, child),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
  /// Wraps the provided child in a nested [Navigator] which intercepts any
  /// pop from the child's navigator (via [onPopPage]) and forwards the
  /// popped `result` to the modal bottom sheet by calling
  /// `Navigator.of(modalContext).pop(result)`. This makes
  /// `Navigator.pop(childContext, data)` behave as if it returned `data`
  /// from the `showModalBottomSheet` Future.
  static Widget _wrapChildForReturn(BuildContext modalContext, Widget child) {
    final navigator = Navigator.of(modalContext);

    return Navigator(
      onPopPage: (Route<dynamic> route, dynamic result) {
        final bool didPop = route.didPop(result);
        if (didPop) {
          // Forward the result to the modal bottom sheet. Use a microtask
          // to avoid calling pop synchronously while the nested route is
          // finishing its own pop handling.
          Future.microtask(() {
            if (navigator.canPop()) {
              navigator.pop(result);
            }
          });
        }
        return didPop;
      },
      pages: [
        MaterialPage(child: child),
      ],
    );
  }

  static Widget _buildHeader(BuildContext context, String header) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drag handle for better UX
          // Container(
          //   width: 40,
          //   height: 4,
          //   decoration: const BoxDecoration(
          //     color: Colors.transparent,
          //   ),
          // ),
          Expanded(
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  static Widget _buildItemsList(
    BuildContext context,
    List items,
    dynamic selectedValue,
    Function(dynamic) onItemSelected,
  ) {
    String display(dynamic item) {
      try {
        if (item == null) return '';
        if (item is String) return item;
        if (item is Map) return (item['name'] ?? item['title'] ?? item.toString()).toString();
        final dynamic name = item.name ?? item.title;
        return (name ?? item.toString()).toString();
      } catch (_) {
        return item.toString();
      }
    }

    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 50,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'No items available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10), // Remove padding to eliminate extra space
      shrinkWrap: true, // Important: makes ListView take only needed space
      physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling if needed
      itemCount: items.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final displayText = display(item);
        final selectedText = selectedValue != null ? selectedValue.toString() : '';
        final isSelected = displayText == selectedText;

        return Container(
          color: isSelected ? AppColors.primaryVariant : Colors.transparent,
          child: ListTile(
            onTap: () {
              // Update selection visually with the display string
              onItemSelected(displayText);

              // Close bottom sheet and return the display string so controller gets a readable value
              Navigator.pop(context, displayText);
            },
            trailing: isSelected
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: TextSize.font12(context),
                    ),
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                    size: TextSize.font18(context),
                  ),
            title: Text(
              displayText,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
                fontSize: TextSize.font16(context),
              ),
            ),
          ),
        );
      },
    );
  }
}
