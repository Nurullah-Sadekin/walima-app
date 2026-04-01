import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/inbox_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/info_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/remind_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            _headerSection(name ?? 'Unknown', imagePath, isOnline ?? false),
            Expanded(child: _conversationBody(provider)),
            _composerSection(provider),
          ],
        ),
      ),
    );
  }

  Widget _headerSection(String displayName, String? imagePath, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 34,
              color: Color(0xFF5B5B5B),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Row(
              children: [
                // _profileAvatar(
                //   imagePath: imagePath ?? AppImages.demoProfile,
                //   size: 60,
                //   showOnlineIndicator: isOnline,
                // ),
                const SizedBox(width: 12),
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
            spacing: 16,
            children: [
              ShowImage(
                imagePath: AppImages.callIcon,
                width: TextSize.font20(context),
                height: TextSize.font20(context),
                color: const Color(0xFF666666),
              ),            InkWell(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.textSecondaryLight,
                  size: TextSize.font22(context),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _conversationBody(ChatProvider provider) {
    bool freeUser = true;
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
          if (!isMe) _profileAvatar(imagePath: AppImages.demoProfile, size: 42),
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
          if (isMe) _profileAvatar(imagePath: AppImages.demoProfile2, size: 42),
        ],
      ),
    );
  }

  Widget _composerSection(ChatProvider provider) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE3E3E3), width: 1))),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
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
                      hintText: 'Type a message',
                      hintStyle: TextStyle(
                          color: Color(0xFF8F8F8F),
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.copy_all_rounded,
                      size: 20, color: Color(0xFF727272))),
              const SizedBox(width: 6),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mic_none_rounded,
                      size: 20, color: Color(0xFF727272))),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _onSendPressed,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9)),
                  child: const Icon(Icons.near_me_rounded,
                      size: 22, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
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
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (showOnlineIndicator)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF11A251),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
