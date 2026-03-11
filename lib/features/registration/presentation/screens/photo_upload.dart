import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/registration/presentation/widgets/know_more_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends ConsumerStatefulWidget {
  const PhotoUploadScreen({super.key});
  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  late RegistrationProvider provider;
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isPickingImage = false;

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
    final screenProvider = ref.watch(photoUploadScreenProvider);
    return TransparentLoading(
      isLoading:
          screenProvider.loaderState == RegistrationScreenStates.isProfileFor ||
              _isPickingImage,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: screenProvider.screenStates ==
                  RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                    const CustomBackAppBar(),
                    body(context),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1800,
      );

      if (!mounted || pickedFile == null) return;

      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to pick image. Please check camera and gallery permissions.',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isPickingImage = false;
      });
    }
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
      context.push(Paths.hobbiesInterests);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.profileImageUploadErrorMessage.isNotEmpty
              ? provider.profileImageUploadErrorMessage
              : 'Failed to upload profile image.',
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          children: [
            photoUploadField(),
            _bodyScrollable(context),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bodyScrollable(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomExpansionTile(
              title: 'Photo Guidelines',
              child: Column(
                children: [
                  ShowImage(
                    imagePath: AppImages.photoGuidelines,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomExpansionTile(
              title: 'Know More',
              child: Column(
                spacing: 8,
                children: [
                  KnowMoreItemCard(
                    text:
                        'Your Photo should be front facing and your entire face should be visible.',
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  KnowMoreItemCard(
                    text:
                        'Ensure that your Photo is recent and not with a group.',
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  KnowMoreItemCard(
                    text: 'You can upload upto 20 Photos to your Profile.',
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  KnowMoreItemCard(
                    text:
                        'Each Photo must be less than 15 MB in size and must be in one of the following formats: jpg, gif, png, bmp or tiff.',
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                  KnowMoreItemCard(
                    text:
                        'Watermarked, digitally enhanced, morphed Photos or Photos with your personal information will be rejected.',
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                  ),
                  KnowMoreItemCard(
                    text:
                        'Irrelevant Photographs will lead to deactivation of your Profile and Membership.',
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget photoUploadField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.greyLight, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        spacing: 20,
        children: [
          _selectedImagePath == null
              ? GestureDetector(
            onTap: () => _pickImage(ImageSource.gallery),
                child: const ShowImage(
                    imagePath: AppImages.photoUpload,
                    radius: BorderRadius.all(Radius.circular(50)),
                    width: 110,
                    height: 110,
                  ),
              )
              : GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: Image.file(
                      File(_selectedImagePath!),
                      width: 110,
                      height: 110,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          Center(
            child: Text(
                _selectedImagePath == null ? 'Upload Image' : 'Image Selected',
                style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight)),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.greyLight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('OR',
                    style: TextStyle(
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondaryLight)),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.greyLight,
                ),
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: _photoActionButton(
                  label: 'Use Camera',
                  icon: Icons.camera_alt_outlined,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ),
              // Expanded(
              //   child: _photoActionButton(
              //     label: 'Use Gallery',
              //     icon: Icons.photo_library_outlined,
              //     onTap: () => _pickImage(ImageSource.gallery),
              //   ),
              // ),
            ],
          ),
          if (_selectedImagePath != null)
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedImagePath = null;
                });
              },
              child: const Text('Remove Photo'),
            ),
        ],
      ),
    );
  }

  Widget _photoActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: AppColors.primaryVariant,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              size: TextSize.font18(context),
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: (_selectedImagePath?.trim().isNotEmpty ?? false)
          ? ButtonsStyle.activePrimaryButton
          : ButtonsStyle.disableButton,
      title: 'Continue',
      onTap: _handleContinue,
    );
  }
}
