import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';

class ProfileCreateStatusScreen extends ConsumerStatefulWidget {
  const ProfileCreateStatusScreen({super.key});
  @override
  ConsumerState<ProfileCreateStatusScreen> createState() =>
      _ProfileCreateStatusScreenState();
}

class _ProfileCreateStatusScreenState
    extends ConsumerState<ProfileCreateStatusScreen> {
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
    final screenProvider = ref.watch(registrationScreenStateProvider);
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    const _CelebrationHeader(),
                    body(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Expanded(child: Center(child: completeMessage())),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget completeMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Well done!',
            style: TextStyle(
              fontSize: TextSize.font20(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          Text(
            'Your profile has been created. You can now update your details to make it stand out. Start by uploading photos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.iconicDynamicButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: () async {
        await provider.saveRegistrationProgress(verificationDone: true);
        if (context.mounted) {
          context.push(Paths.partnerPreferences);
        }
      },
    );
  }
}

class _CelebrationHeader extends StatelessWidget {
  const _CelebrationHeader();

  static const List<Alignment> _directions = <Alignment>[
    Alignment(-1, -0.7),
    Alignment(-0.65, -1),
    Alignment(0, -1),
    Alignment(0.7, -0.9),
    Alignment(1, -0.35),
    Alignment(0.9, 0.65),
    Alignment(-0.8, 0.75),
    Alignment(-1, 0.1),
  ];

  static const List<Color> _colors = <Color>[
    AppColors.primary,
    Colors.amber,
    Colors.teal,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return SizedBox(
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < _directions.length; i++)
                Transform.translate(
                  offset: Offset(
                    _directions[i].x * 75 * value,
                    _directions[i].y * 55 * value,
                  ),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: value * (i.isEven ? 2.4 : -2.4),
                      child: Container(
                        width: i.isEven ? 9 : 6,
                        height: i.isEven ? 6 : 10,
                        decoration: BoxDecoration(
                          color: _colors[i],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              Transform.scale(
                scale: value,
                child: child,
              ),
            ],
          ),
        );
      },
      child: const ShowImage(
        imagePath: AppImages.done,
        width: 88,
        height: 88,
      ),
    );
  }
}
