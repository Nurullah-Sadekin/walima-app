import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/registration/presentation/widgets/hobbies_interests_custom_card.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HobbiesInterestsScreen extends ConsumerStatefulWidget {
  const HobbiesInterestsScreen({super.key});
  @override
  ConsumerState<HobbiesInterestsScreen> createState() =>
      _HobbiesInterestsScreenState();
}

class _HobbiesInterestsScreenState
    extends ConsumerState<HobbiesInterestsScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.loadHobbyLookupData();
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
    final screenProvider = ref.watch(hobbiesInterestsScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor ||
              provider.isLookupDataLoading,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    CustomBackAppBar(
                      trailingText: 'Skip',
                      isTrailing: true,
                      onTrailingTap: () {
                        context.push(Paths.familyDetails);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Column(
          children: [
            _bodyScrollable(context),
            bottomAction(),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _bodyScrollable(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Hobbies & Interests'.localized(context),
                  style: TextStyle(
                      fontSize: TextSize.font18(context),
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.bold)),
              Text(
                  'Helps us suggest more compatible matches'.localized(context),
                  style: TextStyle(
                      fontSize: TextSize.font14(context),
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HobbiesInterestsCard(
                    dataList: provider.creativeItemList,
                    title: 'Creative',
                    onItemTap: (index) {
                      provider.toggleHobbySelection(
                          index, provider.creativeItemList,
                          context: context);
                    },
                  ),
                  HobbiesInterestsCard(
                    dataList: provider.funItemList,
                    title: 'Fun',
                    onItemTap: (index) {
                      provider.toggleHobbySelection(index, provider.funItemList,
                          context: context);
                    },
                  ),
                  HobbiesInterestsCard(
                    dataList: provider.fitnessItemList,
                    title: 'Fitness',
                    onItemTap: (index) {
                      provider.toggleHobbySelection(
                          index, provider.fitnessItemList,
                          context: context);
                    },
                  ),
                  HobbiesInterestsCard(
                    dataList: provider.otherInterestsItemList,
                    title: 'Media & Learning',
                    onItemTap: (index) {
                      provider.toggleHobbySelection(
                          index, provider.otherInterestsItemList,
                          context: context);
                    },
                  ),
                  HobbiesInterestsCard(
                    dataList: provider.foodCuisineItemList,
                    title: 'Food & Cuisine',
                    onItemTap: (index) {
                      provider.toggleHobbySelection(
                        index,
                        provider.foodCuisineItemList,
                        context: context,
                      );
                    },
                  ),
                  HobbiesInterestsCard(
                    dataList: provider.travelLeisureItemList,
                    title: 'Travel & Leisure',
                    onItemTap: (index) {
                      provider.toggleHobbySelection(
                        index,
                        provider.travelLeisureItemList,
                        context: context,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAction() {
    final selected = provider.selectedHobbiesCount();
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      verticalPadding: 14,
      borderRadius: 50,
      title:
          '${'Save & Continue'.localized(context)} ($selected/${RegistrationProvider.hobbiesSelectionMax})',
      onTap: () async {
        // show the save selected hobbies dialog
        final screenProvider = ref.watch(hobbiesInterestsScreenProvider);
        screenProvider.updateViewState(
            loadingState: RegistrationScreenStates.isProfileFor);
        log('Selected Hobbies: ${provider.selectedHobbies}');
        final updated = await provider.updateHobies();
        screenProvider.updateViewState(
            loadingState: RegistrationScreenStates.loadingComplete);
        if (updated) {
          if (mounted) {
            context.push(Paths.familyDetails);
          }
        }
        // context.push(Paths.familyDetails);
      },
    );
  }
}
