import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/connect_now_card.dart';
import 'package:flutter_boilerplate/core/global/components/preference_connect_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/generated/l10n/app_localizations.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSelected = false;
  @override
  void initState() {
    super.initState();
    ref.read(homeProvider).getInitialData();
    // You can fetch initial data here if needed
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(Paths.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              PreferenceConnectCard(
                isSelected: _isSelected,
                onTap: () {
                  setState(() {
                    _isSelected = !_isSelected;
                  });
                },
                imagePath: AppImages.demoProfile,
                name: 'Profile Name',
                age: '28 Years',
                height: '5 Feet 3 Inches',
                religion: 'Muslim, Sunni',
                location: 'Gulshan, Dhaka, BD',
              ),
              const ConnectNowCard(
                imagePath: AppImages.demoProfile,
                iconPath: AppImages.premiumSvgIcon,
                isPremiumConnect: true,
                name: 'Profile Name',
                age: '28 Years',
                height: '5 Feet 3 Inches',
                location: 'Gulshan, Dhaka, BD',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
