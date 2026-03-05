import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/selected_button.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class ProfessionScreen extends ConsumerStatefulWidget {
  const ProfessionScreen({super.key});
  @override
  ConsumerState<ProfessionScreen> createState() => _ProfessionScreenState();
}

class _ProfessionScreenState extends ConsumerState<ProfessionScreen> {
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
                    const UpperLayer(imagePath: AppImages.profession),
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
      children: [


        // Income Yes/No
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
              List.generate(provider.incomePeriodDataList.length, (index) {
                final incomePeriod = provider.incomePeriodDataList[index];

                double screenWidth = MediaQuery.of(context).size.width - 40;
                double itemWidth = (screenWidth - 10) / 2;

                return SizedBox(
                  width: itemWidth,
                  child: SelectedButtons(
                    buttonStyle: incomePeriod.isSelected
                        ? SelectedButtonsStyle.primeSelectedButton
                        : SelectedButtonsStyle.secondarySelectedButton,
                    onTap: () {
                      provider.selectedIncomePeriod(index);
                    },
                    isSelected: incomePeriod.isSelected,
                    title: incomePeriod.name,
                  ),
                );
              }),
            ),
          ],
        ),

        // Income Range Dropdown
        DropDownField(
          headLine: 'Income Range',
          hintText: 'Select',
          popUpHeader: 'Select Income Range',
          items: provider.incomeRangeList,
          controller: provider.incomeRangeController,
          isSearch: false,
        ),

        // Your Work Dropdown
        DropDownField(
          headLine: 'Your Work with',
          hintText: 'Select',
          popUpHeader: 'Select Your Work',
          items: provider.yourWorkList,
          controller: provider.yourWorkController,
          isSearch: false,
        ),

        // You Work As Dropdown
        DropDownField(
          headLine: 'You Work As',
          hintText: 'Select',
          popUpHeader: 'Select Profession',
          items: provider.youWorkAsList,
          controller: provider.youWorkAsController,
          isSearch: false,
        ),

        PrimaryTextField(
          controller: provider.currentCompanyNameController,
          headLine: 'Your Current Company Name',
          hintText: 'Write here',
          errorText: null,
          noPrefix: true,
          onTap: () {},
        ),

      ],
    );
  }

  Widget bottomAction() {
    final hasAnyValue = provider.currentCompanyNameController.text.isNotEmpty ||
        provider.selectedIncomePeriodStatus != null ||
        provider.incomeRangeController.text.isNotEmpty ||
        provider.yourWorkController.text.isNotEmpty ||
        provider.youWorkAsController.text.isNotEmpty;

    return PrimaryButtons(
      buttonStyle: provider.currentCompanyNameController.text.isNotEmpty &&
          provider.selectedIncomePeriodStatus != null &&
          provider.incomeRangeController.text.isNotEmpty &&
          provider.yourWorkController.text.isNotEmpty &&
          provider.youWorkAsController.text.isNotEmpty ? ButtonsStyle.activePrimaryButton : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (!hasAnyValue) return;
        context.push(Paths.aboutYourself);
        // proceed
      },
    );
  }
}
