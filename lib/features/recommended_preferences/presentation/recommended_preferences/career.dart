import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/dropdown_field.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:go_router/go_router.dart';

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
      isLoading: provider.loaderState == RecommendedPreferencesScreenStates.preferences ||
          provider.isCareerLookupLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: provider.screenStates == RecommendedPreferencesScreenStates.preferences
              ? const Loading()
              : Column(
                  children: [
                    const UpperLayer(imagePath: AppImages.recommendedPreferences),
                    Expanded(child: body(provider)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget body(RecommendedPreferencesProvider rec) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Working As',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
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
                  children: List.generate(provider.professionDataList.length, (index) {
                    final item = provider.professionDataList[index];

                    return SelectionCard(
                      buttonStyle: item.isSelected
                          ? SelectionStyle.selectedCheckbox
                          : SelectionStyle.unSelectedCheckbox,
                      onTap: () {
                        provider.toggleProfession(index);
                      },
                      isSelected: item.isSelected,
                      title: item.name,
                    );
                  }),
                );
              });
            },
          ),
          DropDownField(
            headLine: 'Profession',
            hintText: 'Select',
            popUpHeader: 'Select Profession',
            items: provider.professionDataList,
            controller: provider.professionPreferenceController,
            onTap: provider.loadCareerLookupData,
            isSearch: true,
          ),
          DropDownField(
            headLine: 'Annual Income',
            hintText: 'Select',
            popUpHeader: 'Annual Income',
            items: provider.incomeRangeDataList,
            controller: provider.annualIncomePreferenceController,
            onTap: provider.loadCareerLookupData,
            isSearch: true,
          ),
          const Spacer(),
          bottomAction(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Continue',
      onTap: () {
        context.push(Paths.otherDetails);
      },
    );
  }
}
