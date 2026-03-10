import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class AboutYourselfScreen extends ConsumerStatefulWidget {
  const AboutYourselfScreen({super.key});
  @override
  ConsumerState<AboutYourselfScreen> createState() => _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends ConsumerState<AboutYourselfScreen> {
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
    final screenProvider = ref.watch(aboutYourselfScreenProvider);
    return TransparentLoading(
      isLoading: screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.aboutYourself),
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
            const SizedBox(height: 20),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Type',
                  style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: List.generate(provider.verificationList.length, (index) {
                    final verificationType = provider.verificationList[index];
                    double screenWidth = MediaQuery.of(context).size.width - 40;
                    double itemWidth = (screenWidth - 10) / 3;
                    return SizedBox(
                      width: itemWidth,
                      child: SelectionCard(
                        buttonStyle: verificationType.isSelected ? SelectionStyle.selectedRadio : SelectionStyle.unSelectedRadio,
                        onTap: () {
                          provider.selectedVerificationTypeIndex(index);
                        },
                        isSelected: verificationType.isSelected,
                        title: verificationType.name,
                      ),
                    );
                  }),
                ),
              ],
            ),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    return Column(
      spacing: 20,
      children: [
        PrimaryTextField(
          controller: provider.aboutYourselfController,
          headLine: 'About Yourself',
          hintText: 'Write here ',
          errorText: null,
          onTap: () {},
          maxLine: 5,
          minLine: 5,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.aboutYourselfController.text.isNotEmpty && provider.selectedVerificationType.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: () async {
        if (provider.aboutYourselfController.text.isNotEmpty && provider.selectedVerificationType.isNotEmpty) {
          //transparent loading start
          final screenNotifier = ref.read(emailPhoneScreenProvider);
          screenNotifier.updateViewState(
            loadingState: RegistrationScreenStates.isProfileFor,
          );
          await provider.signUpViaOtp(context).then((_) {
            screenNotifier.updateViewState(
              loadingState: RegistrationScreenStates.loadingComplete,
            );
            // context.pushNamed(RouteNames.registrationLocation);
          });
          // provider.signUpViaOtp().then((_) {
          //   // context.pushNamed(RouteNames.registrationLocation);
          // });

          // screenNotifier.updateViewState(
          //   loadingState: RegistrationScreenStates.loadingComplete,
          // );
        }
      },
    );
  }
}
