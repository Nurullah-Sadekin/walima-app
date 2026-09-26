import 'package:flutter/material.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/features/anchor_point/anchor_point.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:walima_llc/features/registration/presentation/widgets/static_text_widget.dart';

class CareerScreen extends ConsumerStatefulWidget {
  const CareerScreen({super.key});
  @override
  ConsumerState<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends ConsumerState<CareerScreen> {
  late RecommendedPreferencesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(recommendedPreferencesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getInitialData();
      provider.initControllersListener();
      provider.loadCareerLookupData();
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(recommendedPreferencesProvider);
    return TransparentLoading(
      isLoading: provider.loaderState ==
              RecommendedPreferencesScreenStates.preferences ||
          provider.isCareerLookupLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates ==
                  RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
                  children: [
                    UpperLayer(
                      imagePath: AppImages.recommendedPreferences,
                      isShowAppbar: true,
                      isBackButton: true,
                      isTrailing: true,
                      trailingText: 'Skip',
                      onTrailingTap: () {
                        context.push(Paths.connectMatches);
                      },
                    ),
                    Expanded(child: body(provider)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body(RecommendedPreferencesProvider rec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const StaticTextWidget(
            title: 'Partner\'s Work & Income',
            subtitle: 'What career does your ideal prefer have',
          ),
          Expanded(child: dataFields(rec)),
          bottomAction(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget dataFields(RecommendedPreferencesProvider rec) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropDownField(
            headLine: 'Work Sector',
            hintText: 'Select',
            popUpHeader: 'Select Work Sector',
            items: provider.workSectorDataList,
            controller: provider.workSectorPreferenceController,
            onTap: provider.loadCareerLookupData,
            onConfirm: (value) => provider.selectWorkSector(value?.toString()),
            isSearch: true,
          ),
          if (!rec.isNotWorkingSector) ...[
            DropDownField(
              headLine: 'Profession',
              hintText: 'Select',
              popUpHeader: 'Select Profession',
              items: provider.professionDataList,
              controller: provider.professionPreferenceController,
              onTap: provider.loadCareerLookupData,
              onConfirm: (value) =>
                  provider.selectProfession(value?.toString()),
              isSearch: true,
            ),
            DropDownField(
              headLine: 'Annual Income',
              hintText: 'Select',
              popUpHeader: 'Annual Income',
              items: provider.incomeRangeDataList,
              controller: provider.annualIncomePreferenceController,
              onTap: provider.loadCareerLookupData,
              onConfirm: (value) =>
                  provider.selectAnnualIncome(value?.toString()),
              isSearch: true,
            ),
          ],
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
    );
  }
}
