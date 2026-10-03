import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/resend_code_timer.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/account_setting/data/repository/account_settings_repository.dart';

/// Adds and/or verifies a phone number in the signed-in user's contacts.
///
/// - [phone] == null: ask for a new number, `POST /settings/contact/phone`
///   (adds it and sends an SMS OTP), then ask for the code.
/// - [phone] != null: an existing unverified contact; request a fresh OTP via
///   `POST /settings/contact/phone/otp` and go straight to the code step.
///
/// On success, refreshes `/settings/contact` and `/auth/me` and pops `true`.
class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({super.key, this.phone});

  final String? phone;

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  static const _otpLength = 6;

  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  /// The exact phone string the OTP was requested for; sent back on verify.
  String? _pendingPhone;
  bool _isBusy = false;
  Country _country = Country.parse('BD');

  /// National number length for the selected country, taken from its
  /// example mobile number (e.g. BD "1812345678" -> 10 digits).
  int get _nationalLength {
    final length = _country.example.length;
    // E.164 caps the full number at 15 digits.
    return length > 0 ? length : 15 - _country.phoneCode.length;
  }

  bool get _isOtpStep => _pendingPhone != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.phone?.trim();
    if (existing != null && existing.isNotEmpty) {
      _pendingPhone = existing;
      WidgetsBinding.instance.addPostFrameCallback((_) => _resendOtp());
    }
    _otpController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtpForNewPhone() async {
    if (_isBusy || !_phoneFormKey.currentState!.validate()) return;
    final phone = '+${_country.phoneCode}${_phoneController.text.trim()}';
    setState(() => _isBusy = true);
    final response = await AccountSettingsRepository.addPhoneContact(phone);
    if (!mounted) return;
    setState(() {
      _isBusy = false;
      if (response.isSuccess) _pendingPhone = phone;
    });
    _showSnack(response, fallbackSuccess: 'Verification code sent');
  }

  Future<void> _resendOtp() async {
    final phone = _pendingPhone;
    if (phone == null) return;
    final response = await AccountSettingsRepository.resendPhoneOtp(phone);
    if (!mounted) return;
    // On failure (e.g. requested too soon) keep the number and let the user
    // enter a code they already received.
    _showSnack(response, fallbackSuccess: 'Verification code sent');
  }

  Future<void> _verify() async {
    final phone = _pendingPhone;
    final otp = _otpController.text.trim();
    if (_isBusy || phone == null || otp.length != _otpLength) return;

    setState(() => _isBusy = true);
    final response =
        await AccountSettingsRepository.verifyPhoneContact(phone, otp);
    if (!mounted) return;

    if (!response.isSuccess) {
      setState(() => _isBusy = false);
      _showSnack(response, fallbackSuccess: '');
      return;
    }

    // The contact list shows per-number status; the account badge only
    // trusts a fresh /auth/me.
    await Future.wait([
      ref.read(accountSettingProvider).loadContactSettings(),
      ref
          .read(globalProvider)
          .refreshCurrentUserAndQuota(silent: true, force: true),
    ]);
    if (!mounted) return;
    _showSnack(response, fallbackSuccess: 'Phone verified successfully');
    context.pop(true);
  }

  void _showSnack(ApiResponse response, {required String fallbackSuccess}) {
    final message = response.message.isNotEmpty
        ? response.message
        : (response.isSuccess ? fallbackSuccess : 'Something went wrong');
    if (message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            response.isSuccess ? AppColors.success : AppColors.error,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomBackAppBar(
              title: Text(
                (_isOtpStep ? 'Verify Phone Number' : 'Add Phone Number')
                    .localized(context),
              ),
              backIconBackground: AppColors.transparent,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _isOtpStep ? _otpStep() : _phoneStep(),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isBusy || !_canSubmit
                        ? null
                        : (_isOtpStep ? _verify : _sendOtpForNewPhone),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isBusy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            (_isOtpStep ? 'Verify' : 'Send Code')
                                .localized(context),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canSubmit =>
      !_isOtpStep || _otpController.text.trim().length == _otpLength;

  Widget _phoneStep() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text(
            'We will send a 6-digit code by SMS to verify this number.'
                .localized(context),
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
            ),
          ),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            // Re-validate as the user types once an error is shown, so a
            // stale "required" message clears as soon as they fix it.
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            maxLength: _nationalLength,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              // The dial code already covers the trunk prefix, so drop a
              // leading 0 (01812... -> 1812...) unless numbers start with 0.
              if (!_country.example.startsWith('0'))
                FilteringTextInputFormatter.deny(RegExp(r'^0+')),
              LengthLimitingTextInputFormatter(_nationalLength),
            ],
            decoration: InputDecoration(
              labelText: 'Phone Number'.localized(context),
              hintText: _country.example,
              border: const OutlineInputBorder(),
              prefixIcon: _countryCodeButton(),
            ),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'This field is required'.localized(context);
              if (v.length != _nationalLength) {
                return '${'Enter a valid phone number'.localized(context)} '
                    '($_nationalLength ${'digits'.localized(context)})';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _countryCodeButton() {
    return InkWell(
      onTap: _isBusy ? null : _openCountryPicker,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _country.flagEmoji,
              style: TextStyle(fontSize: TextSize.font18(context)),
            ),
            const SizedBox(width: 4),
            Text(
              '+${_country.phoneCode}',
              style: TextStyle(
                color: AppColors.textPrimaryLight,
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.textSecondaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      useSafeArea: true,
      onSelect: (country) {
        if (country.countryCode == _country.countryCode) return;
        setState(() => _country = country);
        // The old digits rarely fit the new country's format.
        _phoneController.clear();
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: Colors.white,
        inputDecoration: InputDecoration(
          hintText: 'Search country'.localized(context),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondaryLight,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.inputBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _otpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Text(
          'Enter the 6-digit code sent to'.localized(context),
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font14(context),
          ),
        ),
        Text(
          _pendingPhone ?? '',
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font16(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: _otpLength,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: TextSize.font20(context),
            fontWeight: FontWeight.w600,
            letterSpacing: 8,
          ),
          decoration: const InputDecoration(
            counterText: '',
            hintText: '------',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _verify(),
        ),
        Center(child: ResendCodeTimer(onResend: _resendOtp)),
      ],
    );
  }
}
