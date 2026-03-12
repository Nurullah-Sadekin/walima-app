import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class EmailPhoneScreen extends ConsumerStatefulWidget {
  const EmailPhoneScreen({super.key});
  @override
  ConsumerState<EmailPhoneScreen> createState() => _EmailPhoneScreenState();
}

class _EmailPhoneScreenState extends ConsumerState<EmailPhoneScreen> {
  late RegistrationProvider provider;
  late Country selectedCountry;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(registrationProvider);
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
                    const UpperLayer(imagePath: AppImages.emailPhone),
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
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    selectedCountry = Country.parse(provider.livingInController.text);
    return Column(
      spacing: 20,
      children: [
        PrimaryTextField(
          controller: provider.emailController,
          headLine: 'Email Address',
          hintText: 'hello@aliguni.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: ShowImage(
            imagePath: AppImages.emailSvgIcon,
            width: TextSize.font18(context),
            height: TextSize.font18(context),
            color: provider.emailController.text.isNotEmpty
                ? AppColors.textPrimaryLight
                : AppColors.hintTextColor,
          ),
          errorText: provider.emailAvailabilityErrorMessage,
          onTap: () {},
        ),
        PrimaryTextField(
          prefixIcon: InkWell(
            onTap: _openCountryPicker,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  if (selectedCountry != null)
                    Text(
                      selectedCountry.flagEmoji,
                      style: const TextStyle(fontSize: 20),
                    )
                  else
                    const Icon(Icons.public,
                        color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    selectedCountry != null
                        ? '+${selectedCountry.phoneCode}'
                        : 'Code',
                    style: TextStyle(
                      color: selectedCountry != null
                          ? AppColors.textPrimaryLight
                          : AppColors.hintTextColor,
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
          keyboardType: TextInputType.phone,
          hintText: '168011685',
          errorText: provider.phoneAvailabilityErrorMessage,
          onTap: null,
          maxLine: 1,
        ),
      ],
    );
  }

  void _openCountryPicker() {
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
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
        borderRadius: BorderRadius.circular(12),
        bottomSheetHeight: 600,
      ),
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
        // _showCountryError.value = false;
      },
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.emailController.text.isNotEmpty &&
              provider.phoneController.text.isNotEmpty
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
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
            selectedCountry.phoneCode,
          );

          if (isAvailable && mounted) {
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
