import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/features/anchor_point/anchor_point.dart';
import 'package:go_router/go_router.dart';

class OtherDetailsScreen extends ConsumerStatefulWidget {
  const OtherDetailsScreen({super.key});
  @override
  ConsumerState<OtherDetailsScreen> createState() => _OtherDetailsScreenState();
}

class _OtherDetailsScreenState extends ConsumerState<OtherDetailsScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
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
    provider = ref.watch(recommendedPreferencesProvider);
    return TransparentLoading(
      isLoading: provider.loaderState == RecommendedPreferencesScreenStates.preferences,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
            children: [
              const UpperLayer(
                  imagePath: AppImages.recommendedPreferences,
                  isShowAppbar: true,
                  isBackButton: true,),
              body(),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Column(
        spacing: 10,
        children: [
          selectionField(),
          bottomAction(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget selectionField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile Manage by',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                const double spacing = 10.0;
                return Consumer(builder: (context, ref, _) {
                  final provider = ref.watch(recommendedPreferencesProvider);
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(provider.profileManageByDataList.length, (index) {
                      final item = provider.profileManageByDataList[index];

                      return SelectionCard(
                        buttonStyle: item.isSelected
                            ? SelectionStyle.selectedCheckbox
                            : SelectionStyle.unSelectedCheckbox,
                        onTap: () {
                          provider.toggleProfileManageBy(index);
                        },
                        isSelected: item.isSelected,
                        title: item.name,
                      );
                    }),
                  );
                });
              },
            ),

            Text(
              'Diet',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const double spacing = 10.0;
                    return Consumer(builder: (context, ref, _) {
                      final provider = ref.watch(recommendedPreferencesProvider);
                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: List.generate(provider.dietDataList.length, (index) {
                          final item = provider.dietDataList[index];

                          return SelectionCard(
                            buttonStyle: item.isSelected
                                ? SelectionStyle.selectedCheckbox
                                : SelectionStyle.unSelectedCheckbox,
                            onTap: () {
                              provider.toggleDiet(index);
                            },
                            isSelected: item.isSelected,
                            title: item.name,
                          );
                        }),
                      );
                    },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        title: 'Continue',
        onTap: () async {
          final success = await provider.updatePreferences(context);
          if (success && context.mounted) {
            if (provider.isDrawerEditFlow) {
              ref.read(currentTabProvider.notifier).state = 0;
              context.goNamed(Routes.anchor);
              return;
            }
            context.push(Paths.connectMatches);
          }
        },
      ),
    );
  }
}
