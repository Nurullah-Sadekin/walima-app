import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class MaritalStatusScreen extends ConsumerStatefulWidget {
  const MaritalStatusScreen({super.key});
  @override
  ConsumerState<MaritalStatusScreen> createState() =>
      _MaritalStatusScreenState();
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
    final screenProvider = ref.watch(maritalStatusScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.maritalStatus, totalProgressCount: 10, currentIndexProgress: 5,showProgress: true),
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
            const StaticTextWidget(title: 'Personal Details', subtitle: 'Tell us a bit more about yourself'),
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
            isRequired: true,
            popUpHeader: 'Select Marital Status',
            items: maritalStatusListDataInserted
                .map((item) => item.name)
                .toList(growable: false),
            controller: provider.maritalStatusController,
            onConfirm: (value) {
              if (value == null) return;
              provider.maritalStatusController.text = value.toString();
            },
            onTap: () {},
            isSearch: true,
          ),
          DropDownField(
            headLine: 'Height',
            hintText: 'Select',
            isRequired: true,
            popUpHeader: 'Select Height',
            items: provider.heightDropdownItems,
            controller: provider.heightDisplayController,
            onConfirm: (value) => provider.selectHeight(value?.toString()),
            onTap: () {},
            isSearch: true,
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
                  color: AppColors.textSecondaryLight
                ),
              ),
              Text(
                '(optional)',
                style: TextStyle(
                  fontSize: TextSize.font10(context),
                  fontWeight: FontWeight.w400,
                  color: AppColors.hintTextColor,
                ),
              ),
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
                    children:
                        List.generate(provider.dietDataList.length, (index) {
                      final dietItems = provider.dietDataList[index];
                      return SelectionCard(
                        borderRadius: 30,
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
      buttonStyle: provider.maritalStatusController.text.isNotEmpty &&
              provider.heightController.text.isNotEmpty
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () {
        if (provider.maritalStatusController.text.isEmpty ||
            provider.heightController.text.isEmpty) {
          return;
        }
        context.push(Paths.qualification);
        // proceed
      },
    );
  }
}
