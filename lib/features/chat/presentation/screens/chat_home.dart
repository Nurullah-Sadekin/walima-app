import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/chat/data/model/response/conversation_list.dart';
import 'package:flutter_boilerplate/features/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/chat_list_item.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/profile_avatar_with_name.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final tabs = ['All', 'Unread', 'Calls'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider).getInitialData();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(chatProvider).getInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(chatProvider);
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _appbarSection(),
              if (provider.loaderState == ChatScreenState.loading)
                const Expanded(child: Loading())
              else
                Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbarSection() {
    return AnchoredAppBar(
      title: 'Chat',
      notificationCount: 26,
      context: context,
    );
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _connectableUser(),
          const SizedBox(height: 16),
          _filterBar(),
          const SizedBox(height: 20),
          _conversationList(),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return _customTabBar();
  }

  Widget _customTabBar() {
    final provider = ref.watch(chatProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        TabBarWidget(
          text: tabs[0],
          isSelected: provider.selectedTabIndex == 0,
          onTap: () => provider.setSelectedTab(0),
        ),
        TabBarWidget(
          text: tabs[1],
          count: provider.unreadCount.toDouble(),
          isSelected: provider.selectedTabIndex == 1,
          onTap: () => provider.setSelectedTab(1),
        ),
        TabBarWidget(
          text: tabs[2],
          isSelected: provider.selectedTabIndex == 2,
          selectedBackgroundColor: AppColors.primary,
          onTap: () => provider.setSelectedTab(2),
        ),
      ],
    );
  }

  Widget _conversationList() {
    final provider = ref.watch(chatProvider);
    switch (provider.selectedTabIndex) {
      case 0:
        return _allTabContent(provider);
      case 1:
        return unreadTabContent(provider);
      case 2:
        return callsTabContent(provider);
      default:
        return _allTabContent(provider);
    }
  }

  Widget _allTabContent(ChatProvider provider) {
    return _conversationContent(
      provider: provider,
      conversations: provider.allConversations,
      emptyMessage: 'No conversations yet',
    );
  }

  Widget _conversationContent({
    required ChatProvider provider,
    required List<Conversations> conversations,
    required String emptyMessage,
  }) {
    if (conversations.isEmpty) {
      return _emptyConversationState(emptyMessage);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(conversations.length, (index) {
        final conversation = conversations[index];
        final participant = provider.getConversationCounterpart(conversation);
        final userName = participant?.displayName?.trim();
        final displayName = (userName?.isNotEmpty ?? false) ? userName! : 'Unknown User';
        final lastMessage = conversation.lastMessage?.trim();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ChatListItem(
            name: displayName,
            imagePath: participant?.profilePictureUrl ?? AppImages.demoProfile2,
            isVerified: participant?.profilePhoto?.isVerified ?? false,
            isOnline: participant?.isOnline,
            lastMessage: (lastMessage?.isNotEmpty ?? false)
                ? lastMessage!
                : 'No message',
            timeAgo: _formatConversationTime(conversation.lastMessageAt),
            onTap: () {
              final payload = {
                'conversationId': conversation.id,
                'participant': {
                  'userId': participant?.userId,
                  'displayName': displayName,
                  'profilePictureUrl': participant?.profilePictureUrl,
                  'isOnline': participant?.isOnline,
                }
              };
              context.pushNamed(Routes.chatScreen, extra: payload);
            },
          ),
        );
      }),
    );
  }

  Widget _emptyConversationState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  String _formatConversationTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '--';

    final parsedDateTime = DateTime.tryParse(dateTime)?.toLocal();
    if (parsedDateTime == null) return '--';

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfMessageDay = DateTime(
      parsedDateTime.year,
      parsedDateTime.month,
      parsedDateTime.day,
    );
    final dayDifference = startOfToday.difference(startOfMessageDay).inDays;

    if (dayDifference == 0) {
      return DateFormat('h:mm a').format(parsedDateTime);
    }

    if (dayDifference == 1) {
      return 'Yesterday';
    }

    if (dayDifference < 7) {
      return DateFormat('EEE').format(parsedDateTime);
    }

    return DateFormat('d MMM').format(parsedDateTime);
  }

  Widget _connectableUser() {
    final provider = ref.watch(chatProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          provider.connectableUsers?.length ?? 0,
          (index) {
            final user = provider.connectableUsers![index];
            return Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
              ),
              child: ProfileAvatarWithName(
                name: user.displayName,
                imagePath: user.profilePictureUrl ?? AppImages.demoProfile2,
                indicatorColor: user.isOnline == true
                    ? AppColors.greenButtonColor
                    : Colors.red,
                onTap: () {
                  final payload = {
                    'conversationId': user.conversationId,
                    'participant': {
                      'userId': user.id,
                      'displayName': user.displayName,
                      'profilePictureUrl': user.profilePictureUrl,
                      'isOnline': user.isOnline,
                    },
                  };
                  context.pushNamed(Routes.chatScreen, extra: payload);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget unreadTabContent(ChatProvider provider) {
    return _conversationContent(
      provider: provider,
      conversations: provider.unreadConversations,
      emptyMessage: 'No unread conversations',
    );
  }

  Widget callsTabContent(ChatProvider provider) {
    return _conversationContent(
      provider: provider,
      conversations: provider.callConversations,
      emptyMessage: 'No calls content',
    );
  }
}
