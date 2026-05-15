import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class EmailPhoneScreen extends ConsumerStatefulWidget {
  const EmailPhoneScreen({super.key, this.fromScreen});
  final String? fromScreen;
  @override
  ConsumerState<EmailPhoneScreen> createState() => _EmailPhoneScreenState();
}

class _EmailPhoneScreenState extends ConsumerState<EmailPhoneScreen> {
  static const String _otpEditFlowSource = 'otpScreen';
  static const String _debugOtpFlowSource = 'debugOtpSignup';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenProvider = ref.watch(emailPhoneScreenProvider);
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
                    const UpperLayer(imagePath: AppImages.emailPhone, totalProgressCount: 10, currentIndexProgress: 3,showProgress: true),
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
            const StaticTextWidget(
              title: 'Contact Details',
              subtitle: 'We\'ll use these to verify and secure your account'
            ),
            dataInsertField(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    final provider = ref.watch(registrationProvider);
    return Column(
      spacing: 20,
      children: [
        PrimaryTextField(
          controller: provider.emailController,
          headLine: 'Email Address',
          hintText: 'your@gmail.com',
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          prefixIcon: ShowImage(
            imagePath: AppImages.emailSvgIcon,
            width: TextSize.font18(context),
            height: TextSize.font18(context),
            color: provider.emailController.text.isNotEmpty
                ? AppColors.primary
                : AppColors.hintTextColor,
          ),
          errorText: provider.emailAvailabilityErrorMessage,
          onTap: () {},
        ),
        PrimaryTextField(
          prefixIcon: InkWell(
            onTap: _openCountryPicker,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text(
                    provider.selectedCountry.flagEmoji,
                    style: TextStyle(fontSize: TextSize.font18(context)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${provider.selectedCountry.phoneCode}',
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font14(context),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down,
                      color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
          isCountryDropdown: true,
          controller: provider.phoneController,
          headLine: 'Phone Number',
          isRequired: true,
          keyboardType: TextInputType.phone,
          hintText: 'Enter phone number',
          length: 10,
          errorText: provider.phoneAvailabilityErrorMessage,
          onTap: null,
          maxLine: 1,
        ),
      ],
    );
  }

  Future<void> _openCountryPicker() async {
    final provider = ref.read(registrationProvider);
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.white,
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        searchTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(
            fontSize: TextSize.font16(context),
            color: AppColors.textSecondaryLight,
          ),
          prefixIcon: Icon(Icons.search,color: AppColors.textSecondaryLight,size: TextSize.font22(context),),
          filled: true,
          fillColor:  AppColors.greyLight.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        bottomSheetHeight: 600,
      ),
      onSelect: (Country country) {
        provider.selectedCountry = country;
        provider.selectedCountryCodeForNumber = country.countryCode;
        setState(() {});
        // _showCountryError.value = false;
      },
    );
  }

  Widget bottomAction() {
    final provider = ref.watch(registrationProvider);
    return PrimaryButtons(
      buttonStyle: provider.emailController.text.isNotEmpty &&
              provider.phoneController.text.isNotEmpty
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () async {
        if (provider.emailController.text.isEmpty ||
            provider.phoneController.text.isEmpty) {
          return;
        }
        final screenNotifier = ref.read(emailPhoneScreenProvider);
        screenNotifier.updateViewState(
          loadingState: RegistrationScreenStates.isProfileFor,
        );

        try {
          final isAvailable = await provider.checkEmailAndPhoneAvailability(
            context,
            provider.selectedCountry.phoneCode,
          );

          if (isAvailable && mounted) {
            if (widget.fromScreen == _otpEditFlowSource) {
              final otpSent = await provider.signUpViaOtp(context);
              if (otpSent && mounted) {
                context.pop();
              }
              return;
            }

            if (kDebugMode && widget.fromScreen == _debugOtpFlowSource) {
              final otpSent = await provider.signUpViaOtp(context);
              if (otpSent && mounted) {
                context.pushNamed(
                  Routes.otpVerifyForSignUp,
                  queryParameters: const {'fromScreen': _debugOtpFlowSource},
                  extra: _debugOtpFlowSource,
                );
              }
              return;
            }

            context.push(Paths.location);
          }
        } finally {
          screenNotifier.updateViewState(
            loadingState: RegistrationScreenStates.defaultLoading,
          );
        }
        // context.push(Paths.maritalStatus);
      },
    );
  }
}
