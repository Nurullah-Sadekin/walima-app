import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class AboutYourselfScreen extends ConsumerStatefulWidget {
  const AboutYourselfScreen({super.key});
  @override
  ConsumerState<AboutYourselfScreen> createState() =>
      _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends ConsumerState<AboutYourselfScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    provider.aboutYourselfController.text = 'I enjoy spending time with friends and value meaningful relationships. I am seeking a partner who is supportive, family-oriented, and composed in nature. If this aligns with what you are looking for, I would be glad to connect.';
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
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.aboutYourself,totalProgressCount: 10,currentIndexProgress: 9,showProgress: true,),
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

            const StaticTextWidget(title: 'About Yourself', subtitle: 'Almost done! A genuine bil helps you find the right match faster'),
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
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children:
                      List.generate(provider.verificationList.length, (index) {
                    final verificationType = provider.verificationList[index];
                    double screenWidth = MediaQuery.of(context).size.width - 40;
                    double itemWidth = (screenWidth - 10) / 3;
                    return SizedBox(
                      width: itemWidth,
                      child: SelectionCard(
                        buttonStyle: verificationType.isSelected
                            ? SelectionStyle.selectedRadio
                            : SelectionStyle.unSelectedRadio,
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
          isRequired: true,
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
      buttonStyle: provider.aboutYourselfController.text.isNotEmpty
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: _handleContinue,
    );
  }

  Future<void> _handleContinue() async {
    final screenProvider = ref.read(aboutYourselfScreenProvider);
    if (provider.aboutYourselfController.text.isNotEmpty ) {
      screenProvider.updateViewState(
        loadingState: RegistrationScreenStates.isProfileFor,
      );
      await provider.signUpViaOtp(context).then((success) {
        if (success) {
          screenProvider.updateViewState(screenStates: RegistrationScreenStates.loadingComplete);
          if (mounted) {
            context.pushReplacementNamed(Routes.otpVerifyForSignUp);
          }
        } else {
          screenProvider.updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
        }
      });
    }
  }
}
