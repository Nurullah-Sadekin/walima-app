import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class YourReligion extends ConsumerStatefulWidget {
  const YourReligion({super.key});
  @override
  ConsumerState<YourReligion> createState() => _YourRegionState();
}

class _YourRegionState extends ConsumerState<YourReligion> {
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
                imagePath: AppImages.religion,
                width: 110,
                height: 110,
              ),
            ),
            textField(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget textField() {
    return Column(
      spacing: 20,
      children: [
        DropDownField(
          headLine: 'Your Religion',
          hintText: 'Select',
          popUpHeader: 'Select Religion',
          items: const ['Islam', 'Hinduism', 'Buddhism', 'Christianity'],
          controller: provider.religion,
          onTap: () {},
          isSearch: true,
        ),
        provider.religion.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
                headLine: 'Community',
                hintText: 'Select',
                popUpHeader: 'Select Community',
                headLineInfoIcon: true,
                items: const ['Islam', 'Hinduism', 'Buddhism', 'Christianity'],
                controller: provider.community,
                onTap: () {
                },
                isSearch: true,
              ),
        provider.religion.text.isEmpty && provider.community.text.isEmpty
            ? const SizedBox.shrink()
            : DropDownField(
                headLine: 'Living In',
                hintText: 'Select',
                popUpHeader: 'Select Living In',
                items: const ['Islam', 'Hinduism', 'Buddhism', 'Christianity'],
                controller: provider.livingIn,
                onTap: () {},
                isSearch: true,
              ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.religion.text.isNotEmpty &&
              provider.community.text.isNotEmpty &&
              provider.livingIn.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        context.push(Paths.yourReligion);
      },
    );
  }
}
