import 'dart:math' as math;

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
  static const String _aboutYourselfEditFlowSource = 'aboutYourself';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).getInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenProvider = ref.watch(registrationScreenStateProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(
                      imagePath: AppImages.emailPhone,
                      totalProgressCount: 11,
                      currentIndexProgress: 5,
                      showProgress: true,
                    ),
                    Expanded(child: body()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                spacing: 10,
                children: [
                  const StaticTextWidget(
                    title: 'Contact Details',
                    subtitle:
                        'We\'ll use these to verify and secure your account',
                  ),
                  dataInsertField(),
                  verificationChoice(),
                  const Spacer(),
                  bottomAction(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget verificationChoice() {
    final provider = ref.watch(registrationProvider);
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify account with',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List<Widget>.generate(provider.verificationList.length,
                (index) {
              final item = provider.verificationList[index];
              return ChoiceChip(
                label: Text(item.name),
                selected: item.isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.white,
                checkmarkColor: AppColors.white,
                side: BorderSide(
                  color:
                      item.isSelected ? AppColors.primary : AppColors.greyLight,
                ),
                labelStyle: TextStyle(
                  color: item.isSelected
                      ? AppColors.white
                      : AppColors.textPrimaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (_) =>
                    provider.selectedVerificationTypeIndex(index),
              );
            }),
          ),
        ],
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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.selectedCountry.flagEmoji,
                    style: TextStyle(fontSize: TextSize.font16(context)),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${provider.selectedCountry.phoneCode}',
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: TextSize.font14(context),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: TextSize.font20(context),
                  ),
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
    final country = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (sheetContext) {
        final availableHeight = MediaQuery.sizeOf(sheetContext).height -
            MediaQuery.paddingOf(sheetContext).top -
            MediaQuery.viewInsetsOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: SizedBox(
            height: math.min(600, availableHeight),
            child: const _CompactCountryPicker(),
          ),
        );
      },
    );
    if (!mounted || country == null) return;

    final provider = ref.read(registrationProvider);
    provider.selectedCountry = country;
    provider.selectedCountryCodeForNumber = country.countryCode;
    setState(() {});
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
        final screenNotifier = ref.read(registrationScreenStateProvider);
        screenNotifier.updateViewState(
          loadingState: RegistrationScreenStates.isProfileFor,
        );

        try {
          final isAvailable = await provider.checkEmailAndPhoneAvailability(
            context,
            provider.selectedCountry.phoneCode,
          );

          if (isAvailable && mounted) {
            if (widget.fromScreen == _aboutYourselfEditFlowSource) {
              context.pop();
              return;
            }

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

class _CompactCountryPicker extends StatefulWidget {
  const _CompactCountryPicker();

  @override
  State<_CompactCountryPicker> createState() => _CompactCountryPickerState();
}

class _CompactCountryPickerState extends State<_CompactCountryPicker> {
  final _searchController = TextEditingController();
  final _countries = CountryService().getAll();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = CountryLocalizations.of(context);
    final countries = _query.isEmpty
        ? _countries
        : _countries
            .where((country) => country.startsWith(_query, localizations))
            .toList();

    return Column(
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 22,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.textPrimaryLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value.trim()),
            style: const TextStyle(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search country',
              hintStyle: TextStyle(
                fontSize: TextSize.font16(context),
                color: AppColors.textSecondaryLight,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.textSecondaryLight,
                size: TextSize.font22(context),
              ),
              filled: true,
              fillColor: AppColors.greyLight.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              final name = localizations
                      ?.countryName(countryCode: country.countryCode)
                      ?.replaceAll(RegExp(r'\s+'), ' ') ??
                  country.name;
              return InkWell(
                onTap: () {
                  country.nameLocalized = name;
                  Navigator.pop(context, country);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      Text(
                        country.flagEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 42,
                        child: Text(
                          '+${country.phoneCode}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(name, style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
