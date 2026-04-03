import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';


class TextTabBar extends StatefulWidget {
  const TextTabBar({super.key,
    this.tabs,
    this.onTabChange,
    this.controller,
    this.isScrollable,
    this.tabAlignment,
    this.padding,
    this.tabHeight,
  });

  final List<String>? tabs;
  final Function(int)? onTabChange;
  final TabController? controller;
  final bool? isScrollable;
  final TabAlignment? tabAlignment;
  final EdgeInsetsGeometry? padding;
  final double? tabHeight;

  @override
  State<TextTabBar> createState() => _TextTabBarState();
}

class _TextTabBarState extends State<TextTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _tabController = widget.controller;
    } else {
      _ownsController = true;
      _tabController = TabController(length: widget.tabs?.length ?? 0, vsync: this);
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _tabController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: AppColors.primary,
      onTap: widget.onTabChange,
      dividerColor: AppColors.hintTextColor,
      isScrollable: widget.isScrollable ?? true,
      tabAlignment: widget.tabAlignment ?? TabAlignment.fill,
      indicatorPadding: const EdgeInsets.all(0),
      padding: widget.padding?? EdgeInsets.zero,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondaryLight,
      labelStyle: TextStyle(
        fontSize: TextSize.font16(context),
        fontWeight: FontWeight.w500,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      controller: _tabController,
      tabs: widget.tabs
          ?.map((e) => Tab(
        height: widget.tabHeight,
        text: e,
      ))
          .toList() ??
          [],
    );
  }
}