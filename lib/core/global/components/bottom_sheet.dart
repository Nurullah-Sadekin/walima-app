// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class BottomSheetUtils {
  /// Shows a bottom sheet with a list of items for single selection (Dropdown style)
  static Future<dynamic> singleItemSelectBottomSheet({
    required BuildContext context,
    required List items,
    required String header,
    dynamic selectedValue,
    String? hintText,
    bool isSearchEnabled = false,
    String? searchHintText,
  }) async {
    // Create a local copy of selected value to manage state
    dynamic tempSelectedValue = selectedValue;
    String searchQuery = '';
    final itemHeight = 70.0;
    final headerHeight = 60.0;
    final searchHeight = isSearchEnabled ? 72.0 : 0.0;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;
    final calculatedHeight =
        (items.length * itemHeight) + headerHeight + searchHeight;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        final keyboardInset = mediaQuery.viewInsets.bottom;
        final availableHeight = mediaQuery.size.height - keyboardInset;
        final bottomSheetHeight = keyboardInset > 0
            ? availableHeight
            : (calculatedHeight > maxHeight ? maxHeight : calculatedHeight);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final filteredItems = isSearchEnabled
                ? items.where((item) {
                    final displayText = _display(item).toLowerCase();
                    return displayText.contains(searchQuery.toLowerCase());
                  }).toList(growable: false)
                : items;

            return AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: bottomSheetHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 4,
                              // margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _buildHeader(context, header),
                        SizedBox(height: isSearchEnabled ? 4 : 0),
                        if (isSearchEnabled)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value.trim();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: searchHintText ?? 'Search',
                                hintStyle: TextStyle(
                                  fontSize: TextSize.font16(context),
                                  color: AppColors.textSecondaryLight,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.textSecondaryLight,
                                  size: TextSize.font22(context),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.greyLight),
                                ),
                                filled: true,
                                fillColor: AppColors.greyLight.withOpacity(0.5),
                              ),
                            ),
                          ),
                        Expanded(
                          child: _buildItemsList(
                            context,
                            filteredItems,
                            tempSelectedValue,
                            (dynamic newValue) {
                              setState(() {
                                tempSelectedValue = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
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
    final mediaQuery = MediaQuery.of(context);
    final maxHeightFactor = fullHeight == true ? 0.88 : 0.75;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final maxHeight = mediaQuery.size.height * maxHeightFactor;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildHeader(BuildContext context, String header) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              header.localized(context),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Close button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 24),
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
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.do_not_disturb_outlined,
              size: 30,
              color: AppColors.disableText,
            ),
            const SizedBox(height: 10),
            Text(
              'No items available'.localized(context),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: 10,
      ), // Remove padding to eliminate extra space
      shrinkWrap: true, // Important: makes ListView take only needed space
      physics:
          const AlwaysScrollableScrollPhysics(), // Enable scrolling if needed
      itemCount: items.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final displayText = _display(item);
        final selectedText =
            selectedValue != null ? selectedValue.toString() : '';
        final isSelected = displayText == selectedText;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryVariant : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
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

  static String _display(dynamic item) {
    try {
      if (item == null) return '';
      if (item is String) return item;
      if (item is Map) {
        return (item['name'] ?? item['title'] ?? item.toString()).toString();
      }
      final dynamic name = item.name ?? item.title;
      return (name ?? item.toString()).toString();
    } catch (_) {
      return item.toString();
    }
  }
}
