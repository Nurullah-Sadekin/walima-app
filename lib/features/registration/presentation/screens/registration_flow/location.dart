import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});
  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
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
                    const UpperLayer(imagePath: AppImages.location),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrimaryTextField(
          controller: provider.cityController,
          headLine: 'City',
          hintText: 'Write here',
          errorText: null,
          noPrefix: true,
          onTap: () {},
        ),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You Live with Your Family',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  List.generate(provider.isWithFamilyDataList.length, (index) {
                final isWithFamily = provider.isWithFamilyDataList[index];

                double screenWidth = MediaQuery.of(context).size.width - 40;
                double itemWidth = (screenWidth - 10) / 2;

                return SizedBox(
                  width: itemWidth,
                  child: SelectionCard(
                    buttonStyle: isWithFamily.isSelected
                        ? SelectionStyle.selectedRadio
                        : SelectionStyle.unSelectedRadio,
                    onTap: () {
                      provider.selectedIsWithFamily(index);
                    },
                    isSelected: isWithFamily.isSelected,
                    title: isWithFamily.name,
                  ),
                );
              }),
            ),
          ],
        ),
        DropDownField(
          headLine: 'Residency Status',
          hintText: 'Select',
          popUpHeader: 'Select Residency Status',
          items: const ['Bangladesh', 'India', 'USA', 'UK'],
          controller: provider.residencyStatusController,
          onTap: () {},
          isSearch: true,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.cityController.text.isNotEmpty &&
              provider.residencyStatusController.text.isNotEmpty &&
              provider.selectedIsWithFamilyStatus != null
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
      if (provider.cityController.text.isEmpty ||
              provider.residencyStatusController.text.isEmpty ||
              provider.selectedIsWithFamilyStatus == null) {
            return;
          }
         context.push(Paths.maritalStatus);
      },
    );
  }
}
