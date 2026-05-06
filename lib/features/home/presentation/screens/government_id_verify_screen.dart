import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';
import 'package:walima_llc/features/matches/presentation/widgets/tab_bar_widget.dart';
import 'package:walima_llc/features/profile/data/model/response/dashboard_response.dart';
import 'package:walima_llc/features/registration/data/models/request/upload_media_request_body.dart';
import 'package:walima_llc/features/registration/data/repository/media_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class GovernmentIdVerifyScreen extends ConsumerStatefulWidget {
  const GovernmentIdVerifyScreen({super.key});

  @override
  ConsumerState<GovernmentIdVerifyScreen> createState() =>
      _GovernmentIdVerifyScreenState();
}

class _GovernmentIdVerifyScreenState
    extends ConsumerState<GovernmentIdVerifyScreen> {
  static const List<String> _documentTypes = [
    'Passport',
    'Driving License',
    'Voter ID',
    'Other',
  ];

  final ImagePicker _imagePicker = ImagePicker();
  final MediaRepository _mediaRepository = MediaRepository();

  String _selectedDocumentType = _documentTypes.first;
  String? _selectedFilePath;
  bool _isPickingFile = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(profileProvider);
    final profile = provider.dashboard?.profile;
    final profileName = profile?.displayName?.trim().isNotEmpty == true
        ? profile!.displayName!.trim()
        : 'Walima Member';
    final profileImage = _profileImagePath(profile);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomBackAppBar(
        backgroundColor: Colors.white,
        backIconBackground: Colors.transparent,
        title: Text(
          'Government ID Verify',
          style: TextStyle(color: AppColors.textPrimaryLight),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      _profileSection(
                        context,
                        profileName: profileName,
                        profileImage: profileImage,
                        isVerified: profile?.isVerified ?? false,
                      ),
                      const SizedBox(height: 28),
                      _documentTypeTabs(context),
                      const SizedBox(height: 14),
                      _uploadCard(context),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
                child: _continueButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileSection(
    BuildContext context, {
    required String profileName,
    required String profileImage,
    required bool isVerified,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 96,
          height: 96,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE5F5F6),
                ),
                child: ClipOval(
                  child: ShowImage(
                    imagePath: profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isVerified)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const ShowImage(
                      imagePath: AppImages.verifiedBadgeSvgIcon,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profileName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font18(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'The badge will be added after verification.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondaryLight,
            fontSize: TextSize.font12(context),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _documentTypeTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: _documentTypes.map((type) {
          return TabBarWidget(
            text: type,
            isSelected: _selectedDocumentType == type,
            backgroundColor: const Color(0xFFF7F7F7),
            textColor: AppColors.textSecondaryLight,
            borderColor: const Color(0xFFF0F0F0),
            borderRadius: 10,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            fontSize: TextSize.font12(context),
            selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.08),
            selectedTextColor: AppColors.primary,
            selectedBorderColor: AppColors.primary.withValues(alpha: 0.55),
            onTap: () {
              setState(() {
                _selectedDocumentType = type;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _uploadCard(BuildContext context) {
    final hasFile = _selectedFilePath?.trim().isNotEmpty == true;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _isPickingFile ? null : _pickDocument,
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(vertical: hasFile ? 16 : 56, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9E9E9)),
        ),
        child: hasFile
            ? _selectedFilePreview(context)
            : _emptyUploadState(context),
      ),
    );
  }

  Widget _emptyUploadState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: _isPickingFile
                ? const SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const ShowImage(
                    imagePath: AppImages.photoUpload,
                    width: 100,
                    height: 100,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            _isPickingFile ? 'Picking File...' : 'Upload File',
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedFilePreview(BuildContext context) {
    final filePath = _selectedFilePath!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(filePath),
            width: double.infinity,
            height: 180,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: _isPickingFile ? null : _pickDocument,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Replace File'),
        ),
      ],
    );
  }

  Widget _continueButton(BuildContext context) {
    final isBusy = _isSubmitting || _isPickingFile;

    return SizedBox(
      width: double.infinity,
      child: PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        onTap: isBusy ? () {} : _submitDocument,
        title: _isSubmitting ? 'Uploading...' : 'Continue',
      ),
    );
  }

  Future<void> _pickDocument() async {
    if (_isPickingFile) return;

    setState(() {
      _isPickingFile = true;
    });

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (!mounted || pickedFile == null) return;

      setState(() {
        _selectedFilePath = pickedFile.path;
      });
    } on PlatformException catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied. Please allow photo library access and try again.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Unable to pick the document right now. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingFile = false;
        });
      }
    }
  }

  Future<void> _submitDocument() async {
    final filePath = _selectedFilePath?.trim() ?? '';
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a document first.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _mediaRepository.uploadMedia(
        UploadMediaRequestBody(
          filePath: filePath,
          alt: '$_selectedDocumentType verification document',
          caption: _selectedDocumentType,
          description: 'Government ID verification file upload',
        ),
      );

      if (!mounted) return;

      if (response.code == 'SUCCESS' && response.response?.data?.id != null) {
        DialogUtils.showSuccessDialog(
            context: context,
            title: response.code ?? 'Verify Done',
            message:
                response.message ?? 'Verification complete! Instant alerts for matches and profile views are now active.',
            autoClose: false,
            onButtonPressed: () {
              Navigator.pop(context);
              context.pop();
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ??
                  'Unable to upload the document. Please try again.',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong while uploading the document.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _profileImagePath(Profile? profile) {
    final picture = profile?.profilePicture;
    if (picture != null && picture.url!.isNotEmpty) {
      return picture.url!.trim();
    }

    final gender = profile?.gender?.toLowerCase();
    return gender == 'female' ? AppImages.womenAvatar : AppImages.manAvatar;
  }
}
