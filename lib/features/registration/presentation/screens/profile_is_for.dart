import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/profile_type_card.dart';
import 'package:walima_llc/core/global/components/progress_indicator.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class IsProfileForScreen extends ConsumerStatefulWidget {
  const IsProfileForScreen({super.key});
  @override
  ConsumerState<IsProfileForScreen> createState() => _IsProfileForScreenState();
}

class _IsProfileForScreenState extends ConsumerState<IsProfileForScreen> {
  late RegistrationProvider provider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
    final screenProvider = ref.watch(profileIsForScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.isProfileFor, totalProgressCount: 5, currentIndexProgress: 0,showProgress: true),
                    body(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 10,
          children: [
            isProfileForView(),
            const SizedBox(height: 10),
            provider.selectedProfileName == null
                ? const SizedBox.shrink()
                : genderView(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget isProfileForView() {
    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            Text(
              'This Profile is for',
              style: TextStyle(
                fontSize: TextSize.font20(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(provider.profileForList.length, (index) {
            final isProfileFor = provider.profileForList[index];
            return IsProfileForItemWidget(
              title: isProfileFor.name,
              imagePath: isProfileFor.emoji,
              isSelected: isProfileFor.isSelected,
              onTap: () {
                ref.read(registrationProvider).selectedProfileFor(index);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget genderView() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 4,
          children: [
            Text(
              'Gender',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '*',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(provider.genderForList.length, (index) {
            final genderFor = provider.genderForList[index];

            double screenWidth = MediaQuery.of(context).size.width - 40;
            double itemWidth = (screenWidth - 10) / 2;

            return SizedBox(
              width: itemWidth,
              child: IsProfileForItemWidget(
                title: genderFor.name,
                imagePath: genderFor.emoji,
                isSelected: genderFor.isSelected,
                showIcon: true,
                onTap: () {
                  ref.read(registrationProvider).selectedGender(index);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.selectedProfileName != null &&
              provider.selectedGenderName != null
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        if (provider.selectedProfileName == null ||
            provider.selectedGenderName == null) {
          return;
        }
        context.push(Paths.aboutYou);
        // Handle continue action
      },
    );
  }
}
