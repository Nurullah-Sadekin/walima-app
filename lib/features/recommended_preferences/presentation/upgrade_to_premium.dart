import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/preference_connect_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateToPremium extends ConsumerStatefulWidget {
  const UpdateToPremium({super.key});

  @override
  ConsumerState<UpdateToPremium> createState() => _UpdateToPremiumState();
}

class _UpdateToPremiumState extends ConsumerState<UpdateToPremium> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: Column(
            children: [
              CustomBackAppBar(
                isBackButton: true,
                isTrailing: true,
                trailingText: 'Skip',
                onTrailingTap: () {
                  context.push(Paths.anchor);
                  // Handle skip action
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PreferenceConnectCard(
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
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
      ),
    );
  }
}
