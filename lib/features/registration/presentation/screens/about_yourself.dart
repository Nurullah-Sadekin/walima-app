import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/primary_textField.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/registration/presentation/providers/registration_provider.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class AboutYourselfScreen extends ConsumerStatefulWidget {
  const AboutYourselfScreen({super.key});
  @override
  ConsumerState<AboutYourselfScreen> createState() =>
      _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends ConsumerState<AboutYourselfScreen> {
  late RegistrationProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(registrationProvider);
  WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.aboutYourselfController.text = 'I enjoy spending time with friends and value meaningful relationships. I am seeking a partner who is supportive, family-oriented, and composed in nature. If this aligns with what you are looking for, I would be glad to connect.';
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
    final screenProvider = ref.watch(aboutYourselfScreenProvider);
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
                    const UpperLayer(imagePath: AppImages.aboutYourself,totalProgressCount: 10,currentIndexProgress: 8,showProgress: true,),
                    body(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          spacing: 10,
          children: [

            const StaticTextWidget(title: 'About Yourself', subtitle: 'Almost done!\n A well-written bio helps you get 3x more profile views'),
            bioTemplateActionButtons(),
            dataInsertField(),
            const SizedBox(height: 20),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Type',
                  style: TextStyle(
                    fontSize: TextSize.font14(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children:
                      List.generate(provider.verificationList.length, (index) {
                    final verificationType = provider.verificationList[index];
                    double screenWidth = MediaQuery.of(context).size.width - 40;
                    double itemWidth = (screenWidth - 10) / 3;
                    return SizedBox(
                      width: itemWidth,
                      child: SelectionCard(
                        buttonStyle: verificationType.isSelected
                            ? SelectionStyle.selectedRadio
                            : SelectionStyle.unSelectedRadio,
                        onTap: () {
                          provider.selectedVerificationTypeIndex(index);
                        },
                        isSelected: verificationType.isSelected,
                        title: verificationType.name,
                      ),
                    );
                  }),
                ),
              ],
            ),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget bioTemplateActionButtons() {
    final smallOutlineStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      textStyle: TextStyle(
        fontSize: TextSize.font12(context),
        fontWeight: FontWeight.w600,
      ),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          OutlinedButton.icon(
            style: smallOutlineStyle,
            onPressed: provider.isBioTemplateSuggesting
                ? null
                : () => provider.suggestAndApplyBioTemplate(context),
            icon: provider.isBioTemplateSuggesting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Icon(Icons.auto_fix_high, size: 18),
            label: const Text('Auto Suggest'),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            style: smallOutlineStyle,
            onPressed:
                provider.isBioTemplatesLoading ? null : _handleShowTemplates,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (provider.isBioTemplatesLoading) ...[
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Text('Show Templates'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleShowTemplates() async {
    await provider.loadBioTemplates(context);
    if (!mounted) return;
    if (provider.bioTemplates.isEmpty) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select A Bio Template',
                          style: TextStyle(
                            fontSize: TextSize.font18(context),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 22),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: provider.bioTemplates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (itemContext, index) {
                      final template = provider.bioTemplates[index];
                      return InkWell(
                        onTap: () {
                          provider.applyBioTemplate(template, context: context);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.greyLight),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template.title,
                                style: TextStyle(
                                  fontSize: TextSize.font14(context),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                template.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: TextSize.font13(context),
                                  color: AppColors.textSecondaryLight,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dataInsertField() {
    return Column(
      spacing: 20,
      children: [
        PrimaryTextField(
          controller: provider.aboutYourselfController,
          headLine: 'About Yourself',
          hintText: 'Write here ',
          isRequired: true,
          errorText: null,
          onTap: () {},
          maxLine: 5,
          minLine: 5,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: provider.aboutYourselfController.text.isNotEmpty
          ? ButtonsStyle.iconicDynamicButton
          : ButtonsStyle.disableButton,
      verticalPadding: 14,
      borderRadius: 50,
      svgIconPath: AppImages.arrowRightSvgIcon,
      title: 'Continue',
      onTap: _handleContinue,
    );
  }

  Future<void> _handleContinue() async {
    final screenProvider = ref.read(aboutYourselfScreenProvider);
    if (provider.aboutYourselfController.text.isNotEmpty ) {
      await provider.signUpViaOtp(context).then((success) {
        if (success) {
          screenProvider.updateViewState(screenStates: RegistrationScreenStates.loadingComplete);
          if (mounted) {
            context.push(Paths.otpVerifyForSignUp);
          }
        } else {
          screenProvider.updateViewState(loadingState: RegistrationScreenStates.loadingComplete);
        }
      });
    }
  }
}
