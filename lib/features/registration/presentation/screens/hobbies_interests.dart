import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/hobbies_interests_custom_card.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/know_more_item.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HobbiesInterestsScreen extends ConsumerStatefulWidget {
  const HobbiesInterestsScreen({super.key});
  @override
  ConsumerState<HobbiesInterestsScreen> createState() =>
      _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<HobbiesInterestsScreen> {
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
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const CustomBackAppBar(
                      isTrailing: true,
                      trailingText: 'Skip',
                      //onTrailingTap: () => context.push(Paths.photoUpload),
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
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
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Hobbies & Interests',
                style: TextStyle(
                    fontSize: TextSize.font14(context),
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w500)),
            HobbiesInterestsCard(
              dataList: provider.creativeItemList,
              title: 'Creative',
              onItemTap: (index) {
                provider.toggleHobbySelection(index, provider.creativeItemList);
              },
            ),
            HobbiesInterestsCard(
              dataList: provider.funItemList,
              title: 'Fun',
              onItemTap: (index) {
                provider.toggleHobbySelection(index, provider.funItemList);
              },
            ),
            HobbiesInterestsCard(
              dataList: provider.fitnessItemList,
              title: 'Fitness',
              onItemTap: (index) {
                provider.toggleHobbySelection(index, provider.fitnessItemList);
              },
            ),
            HobbiesInterestsCard(
              dataList: provider.otherInterestsItemList,
              title: 'Other Interests',
              onItemTap: (index) {
                provider.toggleHobbySelection(index, provider.otherInterestsItemList);
              },
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget bottomAction() {
    final selected = provider.selectedHobbiesCount();
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title:
          'Save & Continue ($selected/${RegistrationProvider.hobbiesSelectionMax})',
      onTap: () {
        context.push('/registration/verification');
      },
    );
  }
}
