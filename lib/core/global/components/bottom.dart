import 'package:flutter/material.dart';

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
              height: MediaQuery.of(context).size.height * 0.6, // Slightly reduced height
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header section with drag handle
                  _buildHeader(context, header),

                  // Divider
                  const Divider(height: 1, thickness: 1),

                  // Items list
                  Expanded(
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
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(height: 1),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedValue;

        return Container(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          child: ListTile(
            onTap: () {
              // Update selection visually
              onItemSelected(item);

              // Close bottom sheet and return the selected item
              Navigator.pop(context, item);
            },
            leading: isSelected
                ? Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            )
                : const Icon(
              Icons.radio_button_unchecked,
              color: Colors.grey,
              size: 20,
            ),
            title: Text(
              item.toString(),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Alternative: Compact dropdown style without radio buttons
  static Future<dynamic> compactDropdownSheet({
    required BuildContext context,
    required List items,
    required String header,
    dynamic selectedValue,
  }) async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  header,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),

              // Items
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item == selectedValue;

                    return ListTile(
                      onTap: () => Navigator.pop(context, item),
                      title: Text(
                        item.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}