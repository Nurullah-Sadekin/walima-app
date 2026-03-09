import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class MaritalStatusScreen extends ConsumerStatefulWidget {
  const MaritalStatusScreen({super.key});
  @override
  ConsumerState<MaritalStatusScreen> createState() => _MaritalStatusScreenState();
}

class _MaritalStatusScreenState extends ConsumerState<MaritalStatusScreen> {
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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.maritalStatus),
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
            dataInsertField(),

            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          DropDownField(
            headLine: 'Marital Status',
            hintText: 'Select',
            popUpHeader: 'Select Marital Status',
            items: const ['Single', 'Married', 'Divorced', 'Widowed'],
            controller: provider.maritalStatusController,
            onTap: () {},
            isSearch: false,
          ),
          DropDownField(
            headLine: 'Height',
            hintText: 'Select',
            popUpHeader: 'Select Height',
            items: const ['170 cm', '171 cm', '172 cm', '173 cm', '174 cm', '175 cm'],
            controller: provider.heightController,
            onTap: () {},
            isSearch: false,
          ),
          Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Diet',
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),

              Icon(Icons.info, size: TextSize.font13(context), color:AppColors.disableText),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double spacing = 10.0;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(provider.dietDataList.length, (index) {
                      final dietItems = provider.dietDataList[index];

                      return SelectionCard(
                        buttonStyle: dietItems.isSelected
                            ? SelectionStyle.selectedRadio
                            : SelectionStyle.unSelectedRadio,
                        onTap: () {
                          provider.selectedDiet(index);
                        },
                        isSelected: dietItems.isSelected,
                        title: dietItems.name,
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.maritalStatusController.text.isNotEmpty &&  provider.heightController.text.isNotEmpty && provider.selectedDietStatus != null
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () {
        if (provider.maritalStatusController.text.isEmpty ||
            provider.heightController.text.isEmpty ||
            provider.selectedDietStatus == null) {
          return;
        }
        context.push(Paths.qualification);
        // proceed
      },
    );
  }
}
