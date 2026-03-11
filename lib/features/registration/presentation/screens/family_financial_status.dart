import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/know_more_item.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

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
    final screenProvider = ref.watch(familyFinancialStatusScreenProvider);
    return TransparentLoading(
      isLoading: screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.familyDetails),
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
        spacing: 10,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Live with Family',
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(provider.isWithFamilyDataList.length,
                    (index) {
                  final incomePeriod = provider.isWithFamilyDataList[index];

                  double screenWidth = MediaQuery.of(context).size.width - 40;
                  double itemWidth = (screenWidth - 10) / 2;

                  return SizedBox(
                    width: itemWidth,
                    child: SelectionCard(
                      buttonStyle: incomePeriod.isSelected
                          ? SelectionStyle.selectedRadio
                          : SelectionStyle.unSelectedRadio,
                      onTap: () {
                        provider.selectedIsWithFamily(index);
                      },
                      isSelected: incomePeriod.isSelected,
                      title: incomePeriod.name,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
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
                  title: 'Elite',
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
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
                  title: 'High',
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
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
                  title: 'Middle',
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
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
                  title: 'Aspiring',
                  borderColor: AppColors.primary,
                  backgroundColor: AppColors.primaryVariant,
                  isLeading: true,
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
    final hasAnyValue = provider.selectedIsWithFamilyStatus == null;

    return PrimaryButtons(
      buttonStyle: provider.selectedIsWithFamilyStatus != null
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue & Submit',
      onTap: () async{
        if (hasAnyValue) return;
        final screenProvider = ref.read(familyFinancialStatusScreenProvider);
        screenProvider.updateViewState(loadingState:  RegistrationScreenStates.isProfileFor);
        final updated =await provider.updateFamilyEarning(context);
        screenProvider.updateViewState(loadingState:  RegistrationScreenStates.loadingComplete);
        if(updated && mounted){
          if(context.mounted){
            context.push(Paths.profileCreatedStatus);
          }
        }
        // proceed
      },
    );
  }
}
