import 'dart:io';

import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class CropImageScreen extends ConsumerStatefulWidget {
  const CropImageScreen({super.key, this.imagePath, this.fromScreen});

  final String? imagePath;
  final String? fromScreen;

  @override
  ConsumerState<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends ConsumerState<CropImageScreen> {
  static const String _completeProfileSource = 'completeProfile';

  late RegistrationProvider provider;
  String? _selectedImagePath;

  bool get _isFromCompleteProfile {
    return widget.fromScreen?.trim() == _completeProfileSource;
  }

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    final normalizedPath = widget.imagePath?.trim() ?? '';
    _selectedImagePath = normalizedPath.isEmpty ? null : normalizedPath;

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
    final screenProvider = ref.watch(photoUploadScreenProvider);
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
                    const CustomBackAppBar(),
                    body(),
                    finallyUploadTheCroppedImage(),
                    const SizedBox(height: 30),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(child: showImage()),
      ),
    );
  }

  Widget showImage() {
    final selectedPath = _selectedImagePath?.trim() ?? '';

    if (selectedPath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(selectedPath),
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      );
    }

    return ShowImage(
      imagePath: AppImages.photoUpload,
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      fit: BoxFit.fill,
      radius: BorderRadius.circular(16),
    );
  }

  Future<void> _handleContinue() async {
    final imagePath = _selectedImagePath?.trim() ?? '';
    if (imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image first.')),
      );
      return;
    }

    final screenProvider = ref.read(photoUploadScreenProvider);
    screenProvider.updateViewState(
      loadingState: RegistrationScreenStates.isProfileFor,
    );

    final isUploaded = await provider.uploadProfileImage(filePath: imagePath);

    if (!mounted) return;

    screenProvider.updateViewState(
      loadingState: RegistrationScreenStates.loadingComplete,
    );

    if (isUploaded) {
      if (_isFromCompleteProfile) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return;
      }
      context.push(Paths.hobbiesInterests);
      return;
    }
    DialogUtils.showErrorDialog(
      context: context,
      message: provider.profileImageUploadErrorMessage.isNotEmpty
          ? provider.profileImageUploadErrorMessage
          : 'Failed to upload profile image.',
    );
  }

  Widget finallyUploadTheCroppedImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PrimaryButtons(
        buttonStyle: (_selectedImagePath?.trim().isNotEmpty ?? false)
            ? ButtonsStyle.activePrimaryButton
            : ButtonsStyle.disableButton,
        title: 'Upload Image',
        onTap: _handleContinue,
      ),
    );
  }
}
  
