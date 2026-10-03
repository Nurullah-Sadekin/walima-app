import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/utils/localized_text.dart';

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.borderColor,
    this.borderColorOpen,
    this.borderColorSelected,
    this.borderRadius,
    this.backgroundColor,
    this.titleBackgroundColor,
    this.titleBackgroundColorOpen,
    this.titleBackgroundColorSelected,
    this.collapsedIconColor,
    this.iconColor,
    this.padding,
    this.initiallyExpanded = false,
    this.isLeading = false,
    this.selected = false,
    this.allowDeselect = true,
    this.onSelected,
    this.crossAxisAlignment = CrossAxisAlignment.start, // Default to left
    this.mainAxisAlignment = MainAxisAlignment.start, // Default to left
    this.bottomMargin, // Default bottom margin
  });
  final String title;
  final Widget child;
  final Color? borderColor;
  final Color? borderColorOpen;
  final Color? borderColorSelected;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? titleBackgroundColor;
  final Color? titleBackgroundColorOpen;
  final Color? titleBackgroundColorSelected;
  final Color? collapsedIconColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final bool initiallyExpanded;
  final bool isLeading;
  final bool selected;
  final bool allowDeselect;
  final ValueChanged<bool>? onSelected;
  final CrossAxisAlignment? crossAxisAlignment; // Added for alignment
  final MainAxisAlignment? mainAxisAlignment;
  final double? bottomMargin;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant CustomExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _selected = widget.selected;
    }
  }

  void _handleSelectToggle() {
    final nextSelected = widget.allowDeselect ? !_selected : true;

    if (nextSelected != _selected) {
      setState(() {
        _selected = nextSelected;
      });
    }

    if (widget.onSelected != null) {
      widget.onSelected!(nextSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _isExpanded ? widget.backgroundColor : AppColors.white,
        border: Border.all(
          color: (_isExpanded ? widget.borderColor : AppColors.greyLight) ??
              AppColors.greyLight,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius ?? 8),
        ),
      ),
      // ListTile paints ink on the nearest Material; keep it above the
      // decorated background so splashes stay visible.
      child: Material(
        type: MaterialType.transparency,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: widget.initiallyExpanded,
            onExpansionChanged: (v) => setState(() => _isExpanded = v),
            collapsedIconColor:
                widget.collapsedIconColor ?? AppColors.hintTextColor,
            iconColor: widget.iconColor ?? AppColors.hintTextColor,
            leading: widget.isLeading
                ? GestureDetector(
                    onTap: () {
                      // allow selecting/deselecting via leading
                      _handleSelectToggle();
                    },
                    child: Container(
                      height: TextSize.font16(context),
                      width: TextSize.font16(context),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              _selected ? AppColors.primary : AppColors.greyLight,
                          width: _selected ? 3 : 1,
                        ),
                      ),
                      child: _selected
                          ? const Center(
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  )
                : null,
            title: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.isLeading
                  ? () {
                      // when leading is present, tapping the title should also toggle selection
                      _handleSelectToggle();
                    }
                  : null,
              child: Text(
                widget.title.localized(context),
                style: TextStyle(
                  fontSize: TextSize.font16(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16.0),
                child: Builder(builder: (context) {
                  final maxChildHeight = MediaQuery.of(context).size.height * 0.6;
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxChildHeight),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            widget.crossAxisAlignment ?? CrossAxisAlignment.start,
                        mainAxisAlignment:
                            widget.mainAxisAlignment ?? MainAxisAlignment.start,
                        children: [
                          widget.child,
                        ],
                      ),
                    ),
                  );
                }),
              ),
              widget.bottomMargin != null
                  ? SizedBox(height: widget.bottomMargin)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
