import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/core/global/components/custom_expansion_tile.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/registration/presentation/widgets/know_more_item.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class FamilyFinancialStatusScreen extends ConsumerStatefulWidget {
  const FamilyFinancialStatusScreen({super.key});
  @override
  ConsumerState<FamilyFinancialStatusScreen> createState() =>
      _FamilyFinancialStatusScreenState();
}

class _FamilyFinancialStatusScreenState
    extends ConsumerState<FamilyFinancialStatusScreen> {
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
    final screenProvider = ref.watch(registrationScreenStateProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                     UpperLayer(imagePath: AppImages.familyDetails,
                      trailingText: 'Skip',
                      isTrailing: true,
                      onTrailingTap: () {
                        context.push(Paths.profileCreatedStatus);
                      },
                    ),
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
            const StaticTextWidget(title: 'Family\'s Financial Status', subtitle: 'Helps find compatible matches', isOptional: true),
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
        spacing: 10,
        children: [
          // Column(
          //   spacing: 10,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       'Live with Family',
          //       style: TextStyle(
          //         fontSize: TextSize.font14(context),
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     Wrap(
          //       spacing: 10,
          //       runSpacing: 10,
          //       children: List.generate(provider.isWithFamilyDataList.length,
          //           (index) {
          //         final incomePeriod = provider.isWithFamilyDataList[index];
          //
          //         double screenWidth = MediaQuery.of(context).size.width - 40;
          //         double itemWidth = (screenWidth - 10) / 2;
          //
          //         return SizedBox(
          //           width: itemWidth,
          //           child: SelectionCard(
          //             buttonStyle: incomePeriod.isSelected
          //                 ? SelectionStyle.selectedRadio
          //                 : SelectionStyle.unSelectedRadio,
          //             onTap: () {
          //               provider.selectedIsWithFamily(index);
          //             },
          //             isSelected: incomePeriod.isSelected,
          //             title: incomePeriod.name,
          //           ),
          //         );
          //       }),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          Text(
            'Family\'s Financial Status',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                CustomExpansionTile(
                  title: RegistrationFamilyEconomicCondition.eliteClass.label,
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
                  allowDeselect: false,
                  selected:
                      provider.selectedFamilyEconomicCondition?.toLowerCase() ==
                          RegistrationFamilyEconomicCondition
                              .eliteClass.label
                              .toLowerCase(),
                  onSelected: (isSelected) {
                    provider.onFamilyEconomicConditionSelected(
                      RegistrationFamilyEconomicCondition.eliteClass.label,
                      selected: isSelected,
                    );
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      KnowMoreItemCard(
                        text: 'Your Photo should be front facing and your entire face should be visible.',
                        icon: Icons.circle,
                        iconSize: TextSize.font10(context) / 2,
                        iconPadding: TextSize.font10(context) / 2,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
                CustomExpansionTile(
                  title: RegistrationFamilyEconomicCondition.upperClass.label,
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
                  allowDeselect: false,
                  selected:
                      provider.selectedFamilyEconomicCondition?.toLowerCase() ==
                          RegistrationFamilyEconomicCondition
                              .upperClass.label
                              .toLowerCase(),
                  onSelected: (isSelected) {
                    provider.onFamilyEconomicConditionSelected(
                      RegistrationFamilyEconomicCondition.upperClass.label,
                      selected: isSelected,
                    );
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      KnowMoreItemCard(
                        text:
                            'Your Photo should be front facing and your entire face should be visible.',
                        icon: Icons.circle,
                        iconSize: TextSize.font10(context) / 2,
                        iconPadding: TextSize.font10(context) / 2,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
                CustomExpansionTile(
                  title: RegistrationFamilyEconomicCondition.middleClass.label,
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
                  allowDeselect: false,
                  selected:
                      provider.selectedFamilyEconomicCondition?.toLowerCase() ==
                          RegistrationFamilyEconomicCondition
                              .middleClass.label
                              .toLowerCase(),
                  onSelected: (isSelected) {
                    provider.onFamilyEconomicConditionSelected(
                      RegistrationFamilyEconomicCondition.middleClass.label,
                      selected: isSelected,
                    );
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      KnowMoreItemCard(
                        text:
                            'Your Photo should be front facing and your entire face should be visible.',
                        icon: Icons.circle,
                        iconSize: TextSize.font10(context) / 2,
                        iconPadding: TextSize.font10(context) / 2,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
                CustomExpansionTile(
                  title: RegistrationFamilyEconomicCondition
                      .lowerMiddleClass
                      .label,
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
                  allowDeselect: false,
                  selected:
                      provider.selectedFamilyEconomicCondition?.toLowerCase() ==
                          RegistrationFamilyEconomicCondition
                              .lowerMiddleClass.label
                              .toLowerCase(),
                  onSelected: (isSelected) {
                    provider.onFamilyEconomicConditionSelected(
                      RegistrationFamilyEconomicCondition
                          .lowerMiddleClass
                          .label,
                      selected: isSelected,
                    );
                  },
                  child: Column(
                    spacing: 8,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      KnowMoreItemCard(
                        text:
                            'Your Photo should be front facing and your entire face should be visible.',
                        icon: Icons.circle,
                        iconSize: TextSize.font10(context) / 2,
                        iconPadding: TextSize.font10(context) / 2,
                        iconColor: AppColors.primary,
                      ),
                      const SizedBox(
                        height: 12,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget bottomAction() {
    final hasAnyValue = provider.selectedFamilyEconomicCondition == null;

    return PrimaryButtons(
      buttonStyle: provider.selectedFamilyEconomicCondition != null
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      svgIconPath: AppImages.arrowRightSvgIcon,
      verticalPadding: 14,
      borderRadius: 50,
      title: 'Continue & Submit',
      onTap: () async {
        if (hasAnyValue) return;
        final screenProvider = ref.read(registrationScreenStateProvider);
        screenProvider.updateViewState(
            loadingState: RegistrationScreenStates.isProfileFor);
        final updated = await provider.updateFamilyEarning(context);
        screenProvider.updateViewState(
            loadingState: RegistrationScreenStates.loadingComplete);
        if (updated && mounted) {
          if (context.mounted) {
            context.push(Paths.profileCreatedStatus);
          }
        }
        // proceed
      },
    );
  }
}
