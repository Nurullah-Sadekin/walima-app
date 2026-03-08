import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/custom_expansion_tile.dart';
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

class PhotoUploadScreen extends ConsumerStatefulWidget {
  const PhotoUploadScreen({super.key});
  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  late RegistrationProvider provider;

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
    return TransparentLoading(
      isLoading: provider.loaderState == RegistrationScreenStates.isProfileFor,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.customBackgroundGradient,
          ),
          child: provider.screenStates == RegistrationScreenStates.isProfileFor
              ? const Loading()
              : Column(
                  children: [
                     CustomBackAppBar(
                      isTrailing: true,
                      trailingText: 'Add Photos Later',
                      onTrailingTap: () => context.push(Paths.hobbiesInterests),
                    ),
                    body(context),
                  ],
                ),
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
                    text:
                    'You can upload upto 20 Photos to your Profile.',
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

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget photoUploadField(){
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
          ShowImage(
            imagePath: AppImages.photoUpload,
            width: 110,
            height: 110,
          ),
          Center(
            child: Text('Upload Image',
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
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: AppColors.primaryVariant,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: TextSize.font18(context),
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text('Use Camera',
                    style: TextStyle(
                        fontSize: TextSize.font14(context),
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Continue',
      onTap: () {
          context.push(Paths.hobbiesInterests);
      },
    );
  }
}
