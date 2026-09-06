import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class MarriageIntentionScreen extends ConsumerStatefulWidget {
  const MarriageIntentionScreen({super.key});

  @override
  ConsumerState<MarriageIntentionScreen> createState() =>
      _MarriageIntentionScreenState();
}

class _MarriageIntentionScreenState
    extends ConsumerState<MarriageIntentionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(registrationProvider).loadMarriageOnboardingLookups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(registrationProvider);
    final ready = provider.walimaIntroductionTimelineOptions.isNotEmpty &&
        provider.marriageTimelineOptions.isNotEmpty;
    final complete =
        provider.walimaIntroductionTimelineController.text.trim().isNotEmpty &&
            provider.marriageTimelineController.text.trim().isNotEmpty;
    return TransparentLoading(
      isLoading: !ready,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: Column(
            children: [
              UpperLayer(
                imagePath: AppImages.maritalStatus,
                totalProgressCount: 10,
                currentIndexProgress: 4,
                showProgress: true,
                isTrailing: true,
                trailingText: 'Skip',
                onTrailingTap: () => context.push(Paths.emailPhone),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const StaticTextWidget(
                        title: 'Marriage Intention',
                        subtitle: 'What are your plans for marriage?',
                      ),
                      const SizedBox(height: 24),
                      DropDownField(
                        headLine: 'I\'d like to know someone on Walima for',
                        hintText: 'Select',
                        isRequired: true,
                        popUpHeader: 'Select Timeline',
                        items: provider.walimaIntroductionTimelineOptions
                            .map((item) => item.label)
                            .toList(growable: false),
                        controller:
                            provider.walimaIntroductionTimelineController,
                        onConfirm: (value) =>
                            provider.selectWalimaIntroductionTimeline(
                          value?.toString(),
                        ),
                        isSearch: false,
                      ),
                      const SizedBox(height: 20),
                      DropDownField(
                        headLine: 'I\'d like to get married within',
                        hintText: 'Select',
                        isRequired: true,
                        popUpHeader: 'Select Marriage Timeline',
                        items: provider.marriageTimelineOptions
                            .map((item) => item.label)
                            .toList(growable: false),
                        controller: provider.marriageTimelineController,
                        onConfirm: (value) =>
                            provider.selectMarriageTimeline(value?.toString()),
                        isSearch: false,
                      ),
                      const Spacer(),
                      PrimaryButtons(
                        buttonStyle: complete
                            ? ButtonsStyle.iconicDynamicButton
                            : ButtonsStyle.disableButton,
                        verticalPadding: 14,
                        borderRadius: 50,
                        svgIconPath: AppImages.arrowRightSvgIcon,
                        title: 'Continue',
                        onTap: () {
                          if (!complete) return;
                          context.push(Paths.emailPhone);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
