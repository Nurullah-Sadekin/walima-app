import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
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
  ConsumerState<HobbiesInterestsScreen> createState() => _PhotoUploadScreenState();
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
                trailingText: 'Add Photos Later',
                //onTrailingTap: () => context.push(Paths.photoUpload),
              ),
              _bodyScrollable(context),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: bottomAction(),
          ),
        ),
      ),
    );
  }

  Widget _bodyScrollable(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 12),
              // Header
              Text('Add Hobbies & Interests',
                  style: TextStyle(
                      fontSize: TextSize.font18(context), fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),

              // Show grouped chips using Wrap
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(provider.hobbiesInterestsList.length, (index) {
                    final item = provider.hobbiesInterestsList[index];
                    return SelectionCard(
                      buttonStyle: item.isSelected ? SelectionStyle.selectedItem : SelectionStyle.unSelectedItem,
                      isSelected: item.isSelected,
                      onTap: () {
                        provider.toggleHobbySelection(index);
                      },
                      title: item.name,
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // Optional help / know more
              const CustomExpansionTile(
                title: 'Know More',
                child: Column(
                  spacing: 8,
                  children: [
                    KnowMoreItemCard(
                      text: 'Select up to 5 hobbies you enjoy. These help personalize your profile.',
                      icon: Icons.info,
                      iconColor: Colors.blue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Continue button will be displayed via bottomAction in the scaffold (keeps sticky)
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomAction() {
    final selected = provider.selectedHobbiesCount();
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Save & Continue ($selected/${RegistrationProvider.hobbiesSelectionMax})',
      onTap: () {
        // proceed to next step
        context.push('/registration/verification');
      },
    );
  }
}
