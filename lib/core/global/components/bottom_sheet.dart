import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';

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
    double itemHeight = 56.0; // Approximate height per item
    double headerHeight = 60.0; // Height of header section
    double maxHeight = MediaQuery.of(context).size.height * 0.6; // Max 60% of screen
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
              child: Column(
                mainAxisSize: MainAxisSize.min, // Important: minimizes height
                children: [
                  // Header section with drag handle
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildHeader(BuildContext context, String header) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drag handle for better UX
          Container(
            width: 40,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          Text(
            header,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
        final isSelected = item == selectedValue;

        return Container(
          color: isSelected ? AppColors.primaryVariant : Colors.transparent,
          child: ListTile(
            onTap: () {
              // Update selection visually
              onItemSelected(item);

              // Close bottom sheet and return the selected item
              Navigator.pop(context, item);
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
              item.toString(),
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