import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/contact_bottom_sheet.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:go_router/go_router.dart';

enum InboxMoreMenuAction { viewProfile, viewContact, block, report }

Future<void> showInboxMoreMenu({
  required BuildContext context,
  required Offset tapPosition,
  required String imagePath,
  required String displayName,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final action = await showMenu<InboxMoreMenuAction>(
    context: context,
    color: Colors.white,
    elevation: 8,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 0, 0),
      Offset.zero & overlay.size,
    ),
    items: [
      PopupMenuItem(
        value: InboxMoreMenuAction.viewProfile,
        height: 32,
        padding: const EdgeInsets.fromLTRB(16, 10, 35, 10),
        child: Text('View Profile',
            style: TextStyle(
                fontSize: TextSize.font12(context),
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w400)),
      ),
      PopupMenuItem(
        value: InboxMoreMenuAction.viewContact,
        height: 32,
        padding: const EdgeInsets.fromLTRB(16, 10, 35, 10),
        child: Text('View Contact',
            style: TextStyle(
                fontSize: TextSize.font12(context),
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w400)),
      ),
      PopupMenuItem(
        value: InboxMoreMenuAction.block,
        height: 32,
        padding: const EdgeInsets.fromLTRB(16, 10, 35, 10),
        child: Text('Block',
            style: TextStyle(
                fontSize: TextSize.font12(context),
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w400)),
      ),
      PopupMenuItem(
        value: InboxMoreMenuAction.report,
        height: 32,
        padding: const EdgeInsets.fromLTRB(16, 10, 35, 10),
        child: Text('Report',
            style: TextStyle(
                fontSize: TextSize.font12(context),
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w400)),
      ),
    ],
  );

  if (action == null) return;

  switch (action) {
    case InboxMoreMenuAction.viewProfile:
      context.pushNamed(
        Routes.profilePreview,
        extra: {
          'displayName': displayName,
          'profilePictureUrl': imagePath,
          'profileType': 'Profile Created by Self',
        },
      );
      break;
    case InboxMoreMenuAction.viewContact:
      _showContactPreviewSheet(
        context: context,
        displayName: displayName,
        imagePath: imagePath,
      );
      break;
    case InboxMoreMenuAction.block:
      context.pushNamed(
        Routes.reportStatus,
        extra: {
          'title': 'Blocked Successfully!',
          'subtitle': '$displayName can no longer view your profile or send you messages.',
          'buttonText': 'Done',
          'onTapButton': () {
            if (context.canPop()) {
              context.pop();
            }
            if (context.canPop()) {
              context.pop();
            }
          },
        },
      );
      break;
    case InboxMoreMenuAction.report:
      context.pushNamed(
        Routes.report,
        extra: {
          'displayName': displayName,
          'profilePictureUrl': imagePath,
        },
      );
      break;
  }
}

void _showContactPreviewSheet({
  required BuildContext context,
  required String displayName,
  required String imagePath,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => ContactBottomSheet(
      userName: displayName,
      profileImagePath: imagePath,
      profileType: 'Profile Created by Self',
      description: 'She shares her phone number only with connected members.',
      isDescriptionVisible: false,
      onWalimaChatPressed: () {},
      onWhatsappPressed: () {},
      onCallPressed: () {},
      onConnectionSentPressed: () {},
      onWalimaChatButtonPressed: () {},
    ),
  );
}

Widget buildInboxPlaceholder({
  required BuildContext context,
  required String title,
  required String subtitle,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
