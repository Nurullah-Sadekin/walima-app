import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:go_router/go_router.dart';

class CropImageScreen extends ConsumerStatefulWidget {
  const CropImageScreen({super.key});
  @override
  ConsumerState<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends ConsumerState<CropImageScreen> {
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
    final screenProvider = ref.watch(aboutYouScreenProvider);
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
                    bottomAction(),
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
    return ShowImage(
      imagePath: AppImages.demoProfile,
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      fit: BoxFit.fill,
      radius: BorderRadius.circular(16),
    );
  }

  Widget bottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        title: 'Upload Image',
        onTap: () {
          //context.push(Paths.yourReligion);
        },
      ),
    );
  }
}
