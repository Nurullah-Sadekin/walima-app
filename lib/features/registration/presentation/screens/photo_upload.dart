import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/custom_expansion_tile.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/registration/presentation/widgets/know_more_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends ConsumerStatefulWidget {
  const PhotoUploadScreen({super.key, this.fromScreen});

  static const String completeProfileSource = 'completeProfile';

  final String? fromScreen;

  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  late RegistrationProvider provider;
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isPickingImage = false;

  bool get _isFromCompleteProfile {
    return widget.fromScreen?.trim() == PhotoUploadScreen.completeProfileSource;
  }

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.resetPhotoUploadFlow(notify: false);
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
                    CustomBackAppBar(
                      trailingText: 'Add Photos Later',
                      isTrailing: true,
                      onTrailingTap: () {
                        if (_isFromCompleteProfile) {
                          context.pop();
                          return;
                        }
                        context.push(Paths.hobbiesInterests);
                      },
                    ),
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

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (!mounted || croppedFile == null) return;

      final croppedPath = croppedFile.path.trim();
      if (croppedPath.isEmpty) return;

      final validationError = provider.validateProfileImageFile(croppedPath);
      if (validationError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationError)),
        );
        return;
      }

      setState(() {
        _selectedImagePath = croppedPath;
      });
      provider.resetPhotoUploadFlow();

      if (!mounted) return;
      final normalizedFromScreen = widget.fromScreen?.trim();
      if (normalizedFromScreen != null && normalizedFromScreen.isNotEmpty) {
        context.pushNamed(
          Routes.cropImage,
          queryParameters: {'fromScreen': normalizedFromScreen},
          extra: croppedPath,
        );
      } else {
        context.pushNamed(
          Routes.cropImage,
          extra: croppedPath,
        );
      }
    } on PlatformException catch (e) {
      if (!mounted) return;

      final code = e.code.toLowerCase();
      final message = (code.contains('camera') ||
              code.contains('photo') ||
              code.contains('permission') ||
              code.contains('denied'))
          ? 'Permission denied. Please allow camera/photos access from app settings.'
          : 'Unable to open image picker/cropper. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      debugPrint('Image pick/crop failed: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to process image. Please try a different image.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _handleContinue() async {
    final imagePath = _selectedImagePath?.trim() ?? '';
    final validationError = provider.validateProfileImageFile(imagePath);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    provider.resetPhotoUploadFlow();
    final normalizedFromScreen = widget.fromScreen?.trim();
    if (normalizedFromScreen != null && normalizedFromScreen.isNotEmpty) {
      context.pushNamed(
        Routes.cropImage,
        queryParameters: {'fromScreen': normalizedFromScreen},
        extra: imagePath,
      );
    } else {
      context.pushNamed(
        Routes.cropImage,
        extra: imagePath,
      );
    }
  }

  Widget body(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        'Your photo should be front-facing, clear, and show your full face.',
                    isActive: true,
                  ),
                  KnowMoreItemCard(
                    text:
                        'We verify photos with AI before upload, so use a real and recent solo photo.',
                    isActive: true,
                  ),
                  KnowMoreItemCard(
                    text: 'You can upload upto 20 Photos to your Profile.',
                    isActive: true,
                  ),
                  KnowMoreItemCard(
                    text:
                        'Each photo must be under 5 MB and use jpg, jpeg, png, webp, gif, avif, heic, or heif.',
                    isActive: true,
                  ),
                  KnowMoreItemCard(
                    text:
                        'AI-generated, watermarked, morphed, or publicly reused photos will be rejected.',
                    isActive: false,
                  ),
                  KnowMoreItemCard(
                    text:
                        'Irrelevant Photographs will lead to deactivation of your Profile and Membership.',
                    isActive: false,
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
                color: AppColors.textSecondaryLight,
              ),
            ),
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
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.greyLight,
                ),
              ),
            ],
          ),
          _photoActionButton(
            label: 'Use Camera',
            icon: Icons.camera_alt_outlined,
            onTap: () => _pickImage(ImageSource.camera),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShowImage(
              imagePath: AppImages.cameraUseIcon,
              width: TextSize.font20(context),
              height: TextSize.font20(context),
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
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      svgIconPath: AppImages.arrowRightSvgIcon,
      verticalPadding: 14,
      borderRadius: 50,
      title: 'Continue',
      onTap: _handleContinue,
    );
  }
}
