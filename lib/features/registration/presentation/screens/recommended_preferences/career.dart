import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart' as rn;
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/recommended_preferences_provider.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart' as regp;

class CareerScreen extends ConsumerStatefulWidget {
  const CareerScreen({super.key});
  @override
  ConsumerState<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends ConsumerState<CareerScreen> {
  late RecommendedPreferencesProvider recProvider;

  @override
  void initState() {
    super.initState();
    recProvider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recProvider.getInitialData();
      recProvider.initControllersListener();
    });
  }

  @override
  void dispose() {
    recProvider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rec = ref.watch(recommendedPreferencesProvider);
    return TransparentLoading(
      isLoading: rec.loaderState == regp.RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
          child: rec.screenStates == regp.RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.profession),
                    Expanded(child: body(rec)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body(RecommendedPreferencesProvider rec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        spacing: 10,
        children: [
          // PrimaryTextField(
          //   controller: rec.currentCompanyNameController,
          //   headLine: 'Current Company',
          //   hintText: 'Write here',
          //   errorText: null,
          //   noPrefix: true,
          //   onTap: () {},
          // ),
          // PrimaryTextField(
          //   controller: rec.yourWorkController,
          //   hideHeadline: true,
          //   hintText: 'Your Work',
          //   errorText: null,
          //   noPrefix: true,
          //   onTap: () {},
          // ),

          const Spacer(),

          // PrimaryButtons(
          //   buttonStyle: rec.currentCompanyNameController.text.isNotEmpty ? ButtonsStyle.activePrimaryButton : ButtonsStyle.disableButton,
          //   title: 'Continue',
          //   onTap: () {
          //     if (rec.currentCompanyNameController.text.isEmpty) return;
          //     context.push(rn.Paths.otherDetails);
          //   },
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
