import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'bottom.dart'; // Make sure this imports BottomSheetUtils

class DropDownField extends StatefulWidget {
  final String? hintText;
  final List items;
  final bool? enabled;
  final String popUpHeader;
  final String? searchBoxHintText;
  final TextEditingController? controller;
  final String? headLine;
  final String? icon;
  final Widget? suffix;
  final dynamic errorText;
  final Function(dynamic)? onConfirm;
  final VoidCallback? onTap;
  final bool? noPrefix;
  final bool? hideHeadline;
  final Function(String searchKey)? searchItemList;
  final bool isSearch;
  final String? selectedValue;

  const DropDownField({
    super.key,
    this.controller,
    required this.items,
    this.searchBoxHintText,
    this.hintText,
    this.headLine,
    this.icon,
    this.suffix,
    this.errorText,
    this.onConfirm,
    required this.popUpHeader,
    this.enabled,
    this.noPrefix,
    this.hideHeadline,
    this.searchItemList,
    required this.isSearch,
    this.onTap,
    this.selectedValue,
  });

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      hideHeadline: widget.hideHeadline,
      enabled: widget.enabled,
      controller: widget.controller,
      errorText: widget.errorText,
      noPrefix: widget.noPrefix,
      onTap: () async {
        // Call the provided onTap callback if it exists
        if (widget.onTap != null) {
          widget.onTap!();
        }

        // Show bottom sheet and get selected value
        var dropdownValue = await BottomSheetUtils.singleItemSelectBottomSheet(
          context: context,
          items: widget.items,
          header: widget.popUpHeader,
          selectedValue: widget.selectedValue,
          hintText: widget.hintText,

        );

        // Update if a value was selected
        if (dropdownValue != null) {
          widget.controller?.text = dropdownValue.toString();
          setState(() {});

          // Call onConfirm callback if it exists
          if (widget.onConfirm != null) {
            widget.onConfirm!(widget.controller?.text);
          }
        }
      },
      hintText: widget.hintText,
      icon: widget.icon,
      suffix: widget.suffix ?? const Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.keyboard_arrow_down,
          size: 40,
        ),
      ),
      readOnly: true,
      headLine: widget.headLine,
    );
  }
}