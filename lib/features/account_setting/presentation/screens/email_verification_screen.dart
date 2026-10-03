import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/input_border_style.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/resend_code_timer.dart';
import 'package:walima_llc/core/network/dio_client.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/account_setting/data/repository/account_settings_repository.dart';

/// Adds and/or verifies an email address in the signed-in user's contacts.
///
/// - [email] == null: ask for a new address, `POST /settings/contact/email`
///   (adds it and sends an OTP), then ask for the code.
/// - [email] != null: an existing unverified contact; request a fresh OTP via
///   `POST /settings/contact/email/otp` and go straight to the code step.
///
/// On success, refreshes `/settings/contact` and `/auth/me` and pops `true`.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key, this.email});

  final String? email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  static const _otpLength = 6;

  /// Pill-shaped fields, matching `PrimaryTextField`.
  static const double _fieldRadius = 50;
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _emailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();

  /// The exact email the OTP was requested for; sent back on verify.
  String? _pendingEmail;
  bool _isBusy = false;

  bool get _isOtpStep => _pendingEmail != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.email?.trim();
    if (existing != null && existing.isNotEmpty) {
      _pendingEmail = existing;
      WidgetsBinding.instance.addPostFrameCallback((_) => _resendOtp());
    }
    _otpController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtpForNewEmail() async {
    if (_isBusy || !_emailFormKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    setState(() => _isBusy = true);
    final response = await AccountSettingsRepository.addEmailContact(email);
    if (!mounted) return;
    setState(() {
      _isBusy = false;
      if (response.isSuccess) _pendingEmail = email;
    });
    _showSnack(response, fallbackSuccess: 'Verification code sent');
  }

  Future<void> _resendOtp() async {
    final email = _pendingEmail;
    if (email == null) return;
    final response = await AccountSettingsRepository.resendEmailOtp(email);
    if (!mounted) return;
    // On failure (e.g. requested too soon) keep the address and let the user
    // enter a code they already received.
    _showSnack(response, fallbackSuccess: 'Verification code sent');
  }

  Future<void> _verify() async {
    final email = _pendingEmail;
    final otp = _otpController.text.trim();
    if (_isBusy || email == null || otp.length != _otpLength) return;

    setState(() => _isBusy = true);
    final response =
        await AccountSettingsRepository.verifyEmailContact(email, otp);
    if (!mounted) return;

    if (!response.isSuccess) {
      setState(() => _isBusy = false);
      _showSnack(response, fallbackSuccess: '');
      return;
    }

    await Future.wait([
      ref.read(accountSettingProvider).loadContactSettings(),
      ref
          .read(globalProvider)
          .refreshCurrentUserAndQuota(silent: true, force: true),
    ]);
    if (!mounted) return;
    _showSnack(response, fallbackSuccess: 'Email verified successfully');
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
                (_isOtpStep ? 'Verify Email Address' : 'Add Email Address')
                    .localized(context),
              ),
              backIconBackground: AppColors.transparent,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _isOtpStep ? _otpStep() : _emailStep(),
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
                        : (_isOtpStep ? _verify : _sendOtpForNewEmail),
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

  Widget _emailStep() {
    return Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text(
            'We will send a 6-digit code to verify this email address.'
                .localized(context),
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
            ),
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            decoration: InputDecoration(
              labelText: 'Email Address'.localized(context),
              hintText: 'name@example.com',
              border: InputBorderStyle.border(_fieldRadius),
              enabledBorder: InputBorderStyle.enabledBorder(_fieldRadius),
              focusedBorder: InputBorderStyle.focusedBorder(_fieldRadius),
              errorBorder: InputBorderStyle.errorBorder(_fieldRadius),
              focusedErrorBorder: InputBorderStyle.focusedErrorBorder(_fieldRadius),
              disabledBorder: InputBorderStyle.disabledBorder(_fieldRadius),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: AppColors.textSecondaryLight,
              ),
            ),
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'This field is required'.localized(context);
              if (!_emailPattern.hasMatch(v)) {
                return 'Enter a valid email address'.localized(context);
              }
              return null;
            },
            onFieldSubmitted: (_) => _sendOtpForNewEmail(),
          ),
        ],
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
          _pendingEmail ?? '',
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
          decoration: InputDecoration(
            counterText: '',
            hintText: '------',
            border: InputBorderStyle.border(_fieldRadius),
            enabledBorder: InputBorderStyle.enabledBorder(_fieldRadius),
            focusedBorder: InputBorderStyle.focusedBorder(_fieldRadius),
            errorBorder: InputBorderStyle.errorBorder(_fieldRadius),
            focusedErrorBorder: InputBorderStyle.focusedErrorBorder(_fieldRadius),
            disabledBorder: InputBorderStyle.disabledBorder(_fieldRadius),
            fillColor: Colors.white,
            filled: true,
          ),
          onSubmitted: (_) => _verify(),
        ),
        Center(child: ResendCodeTimer(onResend: _resendOtp)),
      ],
    );
  }
}
