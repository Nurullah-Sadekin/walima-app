import 'dart:async';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'bottom_sheet.dart'; // Make sure this imports BottomSheetUtils

class DropDownField extends StatefulWidget {
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
    this.isRequired = false,
    this.headLineInfoIcon = false,
  });
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
  final FutureOr<void> Function()? onTap;
  final bool? noPrefix;
  final bool? hideHeadline;
  final Function(String searchKey)? searchItemList;
  final bool isSearch;
  final bool? isRequired;
  final bool? headLineInfoIcon;
  final String? selectedValue;

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
      isRequired: widget.isRequired,
      headLineInfoIcon: widget.headLineInfoIcon,
      noPrefix: true,
      onTap: () async {
        if (widget.onTap != null) {
          await widget.onTap!.call();
          if (!mounted) return;
          setState(() {});
          await Future<void>.delayed(Duration.zero);
        }

        if (!context.mounted) return;
        List<dynamic> effectiveItems = List<dynamic>.from(widget.items);
        if (effectiveItems.isEmpty) {
          await WidgetsBinding.instance.endOfFrame;
          if (!context.mounted) return;
          effectiveItems = List<dynamic>.from(widget.items);
        }

        if (effectiveItems.isEmpty) {
          return;
        }

        var dropdownValue = await BottomSheetUtils.singleItemSelectBottomSheet(
          context: context,
          items: effectiveItems,
          header: widget.popUpHeader,
          selectedValue: (widget.controller != null &&
                  (widget.controller!.text).isNotEmpty)
              ? widget.controller!.text
              : widget.selectedValue,
          hintText: widget.hintText,
          isSearchEnabled: widget.isSearch,
          searchHintText: widget.searchBoxHintText,
        );

        if (dropdownValue != null) {
          widget.controller?.text = dropdownValue.toString();
          setState(() {});

          if (widget.onConfirm != null) {
            widget.onConfirm!(widget.controller?.text);
          }
        }
      },
      hintText: widget.hintText,
      icon: widget.icon,
      suffix: widget.suffix ?? Icon(
            Icons.keyboard_arrow_down_outlined,
            size: TextSize.font20(context),
            color: AppColors.grey,
          ),
      readOnly: true,
      headLine: widget.headLine,
      fillColor: Colors.white,
    );
  }
}
