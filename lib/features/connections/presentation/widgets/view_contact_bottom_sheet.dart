import 'package:flutter/material.dart';
import 'package:walima_llc/features/connections/data/models/response/view_contact_info.dart';
import 'package:walima_llc/features/connections/data/repository/connections_repository.dart';
import 'package:walima_llc/features/matches/presentation/widgets/contact_bottom_sheet.dart';

class ViewContactBottomSheet extends StatefulWidget {
  const ViewContactBottomSheet({
    super.key,
    required this.userId,
    required this.userName,
    required this.profileImagePath,
    this.profileType,
    this.description,
    this.isDescriptionVisible = false,
    this.isShowBottom = false,
    this.onWalimaChatPressed,
    this.onWhatsappPressed,
    this.onCallPressed,
    this.onConnectionSentPressed,
    this.onWalimaChatButtonPressed,
    this.chatButtonTitle,
    this.chatButtonIcon,
    this.contactStatus,
  });

  final String userId;
  final String userName;
  final String profileImagePath;
  final String? profileType;
  final String? description;
  final bool isDescriptionVisible;
  final bool isShowBottom;

  final VoidCallback? onWalimaChatPressed;
  final VoidCallback? onWhatsappPressed;
  final VoidCallback? onCallPressed;
  final VoidCallback? onConnectionSentPressed;
  final VoidCallback? onWalimaChatButtonPressed;
  final String? chatButtonTitle;
  final String? chatButtonIcon;
  final String? contactStatus;

  @override
  State<ViewContactBottomSheet> createState() => _ViewContactBottomSheetState();
}

class _ViewContactBottomSheetState extends State<ViewContactBottomSheet> {
  late final Future<ViewContactInfoResult> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<ViewContactInfoResult> _load() async {
    final response = await ConnectionsRepository.viewContact(widget.userId);
    if (!response.isSuccess) {
      return ViewContactInfoResult.error(response.message);
    }
    return ViewContactInfoResult.success(
      response.data ?? const ViewContactInfo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ViewContactInfoResult>(
      future: _future,
      builder: (context, snapshot) {
        final result = snapshot.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        final ViewContactInfo? info =
            result is ViewContactInfoSuccess ? result.info : null;
        final String? error =
            result is ViewContactInfoError ? result.message : null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ContactBottomSheet(
              userName: widget.userName,
              profileImagePath: widget.profileImagePath,
              profileType: widget.profileType,
              description: widget.description,
              isDescriptionVisible: widget.isDescriptionVisible,
              isShowBottom: widget.isShowBottom,
              contactStatus: widget.contactStatus ?? (error ?? 'Contact Viewed'),
              isVerified: info?.isVerified ?? false,
              email: isLoading ? 'Loading…' : info?.email,
              phone: isLoading ? 'Loading…' : info?.phoneNumber,
              onWalimaChatPressed: widget.onWalimaChatPressed,
              onWhatsappPressed: widget.onWhatsappPressed,
              onCallPressed: widget.onCallPressed,
              onConnectionSentPressed: widget.onConnectionSentPressed,
              onWalimaChatButtonPressed: widget.onWalimaChatButtonPressed,
              chatButtonTitle: widget.chatButtonTitle,
              chatButtonIcon: widget.chatButtonIcon,
            ),
          ],
        );
      },
    );
  }
}

sealed class ViewContactInfoResult {
  const ViewContactInfoResult();

  factory ViewContactInfoResult.success(ViewContactInfo info) =
      ViewContactInfoSuccess;
  factory ViewContactInfoResult.error(String message) = ViewContactInfoError;
}

class ViewContactInfoSuccess extends ViewContactInfoResult {
  const ViewContactInfoSuccess(this.info);
  final ViewContactInfo info;
}

class ViewContactInfoError extends ViewContactInfoResult {
  const ViewContactInfoError(this.message);
  final String message;
}
