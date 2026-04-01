import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/profile_avatar_with_name.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/remind_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MoreMenuAction { viewProfile, viewContact, block, report }

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.extra});
  final Map<String, dynamic>? extra;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _participant;
  Timer? _typingStopDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final extra = widget.extra;
    _participant = extra != null && extra['participant'] is Map
        ? extra['participant'] as Map<String, dynamic>
        : null;
    final conversationId =
        extra != null ? extra['conversationId'] as String? : null;
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = ref.read(chatProvider);
      final receiverId = _participant?['userId'] as String?;
      if (conversationId != null && conversationId.isNotEmpty) {
        if (receiverId != null && receiverId.isNotEmpty) {
          provider.setActiveReceiver(receiverId);
        }
        unawaited(provider.openConversation(conversationId));
      } else if (receiverId != null && receiverId.isNotEmpty) {
        unawaited(provider.openDirectChat(
          receiverId: receiverId,
          conversationId: conversationId,
        ));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _typingStopDebounce?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.paused) {
      ref.read(chatProvider).onComposerChanged('');
    } else if (state == AppLifecycleState.resumed) {
      ref.read(chatProvider).markCurrentConversationRead();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final provider = ref.read(chatProvider);
    final threshold = _scrollController.position.maxScrollExtent - 120;
    if (_scrollController.position.pixels >= threshold) {
      unawaited(provider.loadMoreMessages());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatProvider);
    dynamic liveParticipant;
    for (final conversation in provider.allConversations) {
      if (conversation.id == provider.currentConversationId) {
        liveParticipant = provider.getConversationCounterpart(conversation);
        break;
      }
    }
    final name = liveParticipant?.displayName as String? ??
        (_participant != null
            ? (_participant!['displayName'] as String?)
            : null);
    final imagePath = liveParticipant?.profilePictureUrl as String? ??
        (_participant != null
            ? (_participant!['profilePictureUrl'] as String?)
            : null);
    final isOnline = liveParticipant?.isOnline as bool? ??
        (_participant != null ? (_participant!['isOnline'] as bool?) : null);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            _headerSection(name ?? 'Unknown', imagePath, isOnline ?? false, liveParticipant),
            Expanded(child: _conversationBody(provider)),
          ],
        ),
      ),
      floatingActionButton: BottomBorderedWidget(
        widget:  _composerSection(provider),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _headerSection(String displayName, String? imagePath, bool isOnline, dynamic participant) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: TextSize.font18(context),
              color: AppColors.textSecondaryLight,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _profileAvatar(
                  imagePath: imagePath ?? AppImages.demoProfile,
                  size: 48,
                  isOnline: isOnline,
                  showOnlineIndicator: true,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF1F1F1F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      providerStatusText(ref.read(chatProvider), isOnline),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF787878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            spacing: 12,
            children: [
              ShowImage(
                imagePath: AppImages.callIcon,
                width: TextSize.font20(context),
                height: TextSize.font20(context),
                color: const Color(0xFF666666),
              ),
              // Replace the simple InkWell icon with a PopupMenuButton for actions
              PopupMenuButton<MoreMenuAction>(
                onSelected: (action) => _handleMoreMenuAction(action, participant),
                padding: EdgeInsets.zero,
                position: PopupMenuPosition.under,
                color: Colors.white,
                popUpAnimationStyle: AnimationStyle.noAnimation,
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondaryLight,
                  size: TextSize.font22(context),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: MoreMenuAction.viewProfile,
                    height: 32.0,
                    padding:const EdgeInsets.fromLTRB(16, 10, 35, 10),
                    child: Text('View Profile',
                        style: TextStyle(fontSize: TextSize.font12(context), color: AppColors.textPrimaryLight,fontWeight: FontWeight.w400)
                    ),
                  ),
                  PopupMenuItem(
                    value: MoreMenuAction.viewContact,
                    height: 32.0,
                    padding:const EdgeInsets.fromLTRB(16, 10, 35, 10),
                    child: Text('View Contact',
                        style: TextStyle(fontSize: TextSize.font12(context), color: AppColors.textPrimaryLight,fontWeight: FontWeight.w400)
                    ),
                  ),
                  PopupMenuItem(
                    value: MoreMenuAction.block,
                    height: 32.0,
                    padding:const EdgeInsets.fromLTRB(16, 10, 35, 10),
                    child: Text('Block',
                        style: TextStyle(fontSize: TextSize.font12(context), color: AppColors.textPrimaryLight,fontWeight: FontWeight.w400)
                    ),
                  ),
                  PopupMenuItem(
                    value: MoreMenuAction.report,
                    height: 32.0,
                    padding:const EdgeInsets.fromLTRB(16, 10, 35, 10),
                    child: Text('Report',
                        style: TextStyle(fontSize: TextSize.font12(context), color: AppColors.textPrimaryLight,fontWeight: FontWeight.w400)
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // Handler for the popup menu actions. For now show a simple dialog to confirm the action.
  void _handleMoreMenuAction(MoreMenuAction action, dynamic participant) async {
    switch (action) {
      case MoreMenuAction.viewProfile:
        break;
      case MoreMenuAction.viewContact:
        break;
      case MoreMenuAction.block:
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Block ${participant?.displayName}? Are you sure?'),
            content: const Text('Blocked members cannot view your profile or contact you on walima.com.'),
            actions: [
              Row(
                spacing: 8,
                children: [
                  Expanded(child: PrimaryButtons(buttonStyle: ButtonsStyle.cancelButton, onTap: () => Navigator.pop(context), title: 'Cancel',bgColor: Colors.transparent)),
                  Expanded(child: PrimaryButtons(buttonStyle: ButtonsStyle.activePrimaryButton, onTap: (){}, title: 'Block')),
                ],
              )
            ],
          ),
        );
        break;
      case MoreMenuAction.report:
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Report User'),
            content: Text('Report ${participant?.displayName ?? 'this user'} for inappropriate behavior.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(onPressed: () {
                Navigator.pop(context);
                // TODO: call report flow
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User reported')));
              }, child: const Text('Report')),
            ],
          ),
        );
        break;
    }
  }

  Widget _conversationBody(ChatProvider provider) {
    bool freeUser = false;
    if (provider.messagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final message = provider.messages;

    if (message.isEmpty) {
      return const Center(child: Text('No messages yet'));
    }

    return freeUser == true
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                RemindCard(
                  imagePath: AppImages.demoProfile,
                  name: 'name',
                  leftButtonOnTap: () {},
                  rightButtonOnTap: () {},
                  age: '30',
                  height: '176cm',
                  location: 'Dhaka',
                  singleButton: false,
                ),
               Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          ShowImage(
                            imagePath: AppImages.lockPasswordSvgIcon,
                            width: TextSize.font16(context),
                            height: TextSize.font16(context),
                            color: AppColors.textSecondaryLight,
                          ),
                          Flexible(
                            child: Text(
                              'You have 1 unread message from her please view and reply promptly for a smoother conversation.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:  AppColors.textSecondaryLight,
                                fontSize: TextSize.font12(context),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              'Upgrade Now',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:  AppColors.primary,
                                fontSize: TextSize.font14(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ShowImage(
                              imagePath: AppImages.arrowRightSvgIcon,
                              width: TextSize.font16(context),
                              height: TextSize.font16(context),
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
               )
              ],
            ),
          )
        : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            reverse: true,
            itemCount: message.length + (provider.loadingMoreMessages ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == message.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final msg = message[index];
              final isMe = msg.senderId == provider.currentUserId;
              return _textMessageRow(isMe: isMe, message: msg.content ?? '');
            },
          );
  }

  Widget _textMessageRow({required bool isMe, required String message}) {
    final bubbleColor =
        isMe ? const Color(0xFFF4E8EE) : const Color(0xFFEFEFEF);
    final bubbleRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isMe ? 20 : 8),
      bottomRight: Radius.circular(isMe ? 8 : 20),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _profileAvatar(imagePath: AppImages.demoProfile, size: 32),
          if (!isMe) const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              decoration:
                  BoxDecoration(color: bubbleColor, borderRadius: bubbleRadius),
              child: Text(
                message,
                style: const TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 16,
                    height: 1.35,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 10),
          if (isMe) _profileAvatar(imagePath: AppImages.demoProfile2, size: 32),
        ],
      ),
    );
  }

  Widget _composerSection(ChatProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                provider.onComposerChanged(value);
                _typingStopDebounce?.cancel();
                _typingStopDebounce = Timer(
                  const Duration(milliseconds: 900),
                      () => provider.onComposerChanged(''),
                );
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: 'Type a message',
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(
                      color: Color(0xFF8F8F8F),
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ShowImage(
            imagePath: AppImages.albumSvgIcon,
            width: TextSize.font20(context),
            height: TextSize.font20(context),
            color: const Color(0xFF727272),
          ),
          const SizedBox(width: 6),
          ShowImage(
            imagePath: AppImages.micIcon,
            width: TextSize.font28(context),
            height: TextSize.font28(context),
            color: const Color(0xFF727272),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _onSendPressed,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4)),
              child:   ShowImage(
                imagePath: AppImages.sentMessage,
                width: TextSize.font20(context),
                height: TextSize.font20(context),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSendPressed() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final receiverId =
        _participant != null ? (_participant!['userId'] as String?) : null;
    if (receiverId == null || receiverId.isEmpty) return;
    ref.read(chatProvider).onComposerChanged('');
    ref.read(chatProvider).sendMessage(text, receiverId);
    _messageController.clear();
  }

  String providerStatusText(ChatProvider provider, bool isOnline) {
    if (provider.isOtherUserTyping) {
      return 'Typing...';
    }
    return isOnline ? 'Active Now' : 'Offline';
  }

  Widget _profileAvatar({
    required String imagePath,
    required double size,
    bool showOnlineIndicator = false,
    bool isOnline = false,
  }) {
    return  ProfileAvatarWithName(
      imagePath: imagePath,
      indicatorColor: isOnline == true ? AppColors.greenButtonColor : Colors.red,
      showOnlineIndicator: showOnlineIndicator,
      indicatorSize: size * 0.3,
      avatarSize: size,
    );
  }
}
