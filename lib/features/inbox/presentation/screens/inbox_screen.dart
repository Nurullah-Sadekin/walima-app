import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/anchor_point/achore_appbar.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/matcher_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/accepted_card.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/text_tab_bar.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _tabs = const ['Accepted by Her', 'Accepted by Me'];

  MatchesProvider provider = MatchesProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    provider = ref.read(matchesProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(matchesProvider);
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
      title: 'Inbox',
      notificationCount: 26,
      context: context,
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextTabBar(
            isScrollable: false,
            tabAlignment: TabAlignment.fill,
            controller: _tabController,
            onTabChange: (index) {
              //provider?.updateTab(index: index);
            },
            tabs: _tabs),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _tabBarView(),
          ),
        )
      ],
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      controller: _tabController,
      physics: const ScrollPhysics(
        parent: NeverScrollableScrollPhysics(),
      ),
      children: [
        _acceptedByHer(),
        _acceptedByMe(),
      ],
    );
  }

  Widget _acceptedByHer() {
    return  Column(
      children: [
        AcceptedCard(
          onMenuTap: () {
             _showAcceptedMenu(context,
                 imagePath: AppImages.demoProfile2,
                 name: 'Tasnova Ahmed');
          },
          imagePath: AppImages.demoProfile2,
          name: 'Tasnova Ahmed',
          age: '28 Yr',
          height: '5\' 3\'" ',
          day: 'Today',
          location: 'Gulshan, Dhaka, BD',
          isVerified: true,
        ),
      ],
    );
  }

  Widget _acceptedByMe() {
    return Container(
      color: Colors.blue,
      child: const Center(child: Text('Accepted by Me')),
    );
  }

  Future<void> _showAcceptedMenu(BuildContext context, {required String imagePath, required String name}) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShowImage(imagePath: imagePath, width: 56, height: 56, radius: BorderRadius.circular(8)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gulshan, Dhaka, BD',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  // TODO: Navigate to profile screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.message_outlined),
                title: const Text('Send Message'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  // TODO: Open chat screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Remove Match'),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  // TODO: Call provider to remove match
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(sheetCtx).pop(),
                child: Center(
                  child: Text('Cancel', style: TextStyle(color: AppColors.textSecondaryLight)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
