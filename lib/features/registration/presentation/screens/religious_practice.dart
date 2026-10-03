import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class ReligiousPracticeScreen extends ConsumerStatefulWidget {
  const ReligiousPracticeScreen({super.key});

  @override
  ConsumerState<ReligiousPracticeScreen> createState() =>
      _ReligiousPracticeScreenState();
}

class _ReligiousPracticeScreenState
    extends ConsumerState<ReligiousPracticeScreen> {
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
    final options = provider.religiousPracticeOptions;
    return TransparentLoading(
      isLoading: options.isEmpty,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpperLayer(
                imagePath: AppImages.religion,
                totalProgressCount: 11,
                currentIndexProgress: 3,
                showProgress: true,
                isTrailing: true,
                trailingText: 'Skip',
                onTrailingTap: () => context.push(Paths.marriageIntention),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StaticTextWidget(
                        title: 'Religious Practice',
                        subtitle: 'How important is faith in your daily life?',
                      ),
                      const SizedBox(height: 10),
                      
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 0, bottom: 20),
                          itemCount: options.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final option = options[index];
                            final selected = provider
                                    .religiousPracticeController.text
                                    .trim()
                                    .toLowerCase() ==
                                option.label.trim().toLowerCase();
                            return SelectionCard(
                              borderRadius: 14,
                              buttonStyle: selected
                                  ? SelectionStyle.selectedRadio
                                  : SelectionStyle.unSelectedRadio,
                              isSelected: selected,
                              title: option.label,
                              subtitle: option.description,
                              onTap: () => provider.selectReligiousPractice(
                                option.label,
                              ),
                            );
                          },
                        ),
                      ),
                      PrimaryButtons(
                        buttonStyle: provider.religiousPracticeController.text
                                .trim()
                                .isNotEmpty
                            ? ButtonsStyle.iconicDynamicButton
                            : ButtonsStyle.disableButton,
                        verticalPadding: 14,
                        borderRadius: 50,
                        svgIconPath: AppImages.arrowRightSvgIcon,
                        title: 'Continue',
                        onTap: () {
                          if (provider.religiousPracticeController.text
                              .trim()
                              .isEmpty) {
                            return;
                          }
                          context.push(Paths.marriageIntention);
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
