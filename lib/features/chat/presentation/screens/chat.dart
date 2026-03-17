import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/chat_list_item.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/dismissible_safety_card.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/profile_avatar_with_name.dart';
import 'package:flutter_boilerplate/features/chat/presentation/screens/widgets/safety_First_bottom_sheet.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/safety_first_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  ChatProvider provider = ChatProvider();
  final tabs = ['All', 'Unread', 'Calls'];

  @override
  void initState() {
    super.initState();
    provider = ref.read(chatProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(chatProvider);
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _appbarSection(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _topProfileView(),
        const SizedBox(height: 16),
        _headerSection(),
        const SizedBox(height: 20),
        _tabBarViewSection(),
      ],
    );
  }

  Widget _headerSection() {
    return _customTabBar();
  }

  Widget _customTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          TabBarWidget(
            text: tabs[0],
            isSelected: provider.selectedTabIndex == 0,
            onTap: () => provider.setSelectedTab(0),
          ),
          TabBarWidget(
            text: tabs[1],
            count: 28,
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
      ),
    );
  }

  Widget _tabBarViewSection() {
    return Builder(
      builder: (context) {
        switch (provider.selectedTabIndex) {
          case 0:
            return _allTabContent();
          case 1:
            return unreadTabContent();
          case 2:
            return callsTabContent();
          default:
            return _allTabContent();
        }
      },
    );
  }

  Widget _allTabContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ChatListItem(
          name: 'Sumaiya Akter',
          isVerified: true,
          lastMessage: 'Hey! How are you doing?',
          timeAgo: '2:30 PM',
        ),
      ],
    );
  }

  Widget _topProfileView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            10,
            (index) => const Padding(
                  padding: EdgeInsets.only(
                    right: 16.0,
                  ),
                  child: ProfileAvatarWithName(
                    name: 'Sumaiya',
                    imagePath: AppImages.demoProfile,
                  ),
                )),
      ),
    );
  }

  Widget unreadTabContent() {
    return const SafetyFirst();
  }

  Widget callsTabContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        Text('No Calls content'),
      ],
    );
  }
}
