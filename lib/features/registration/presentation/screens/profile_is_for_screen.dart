import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/profile_type_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
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
    return TransparentLoading(
      isLoading: provider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const CustomBackAppBar(),
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ShowImage(
                imagePath: AppImages.isProfileFor,
                width: 110,
                height: 110,
              ),
            ),

            isProfileForView(),

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
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          spacing: 10,
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
        Text(
          'Gender',
          style: TextStyle(
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
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
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
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
