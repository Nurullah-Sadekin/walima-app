import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/contact_bottom_sheet.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:go_router/go_router.dart';

enum InboxMoreMenuAction { cancelRequest, decline, block, report }

/// Handle menu actions directly without requiring TapDownDetails
void handleMenuAction({
  required BuildContext context,
  required InboxMoreMenuAction action,
}) {
  switch (action) {
    case InboxMoreMenuAction.cancelRequest:

      break;
    case InboxMoreMenuAction.decline:

      break;
    case InboxMoreMenuAction.block:

      break;
    case InboxMoreMenuAction.report:

      break;
  }
}
