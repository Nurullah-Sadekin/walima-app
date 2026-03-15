import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_matches_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class SearchMatchesScreen extends ConsumerStatefulWidget {
  const SearchMatchesScreen({super.key});
  @override
  ConsumerState<SearchMatchesScreen> createState() => _SearchMatchesScreenState();
}

class _SearchMatchesScreenState extends ConsumerState<SearchMatchesScreen> {
  late SearchMatchesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(searchMatchesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    });
  }

  @override
  void dispose() {
    provider.disposeControllersListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(searchMatchesProvider);
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GradientBackground(
          child: Column(
            children: [
              const UpperLayer(imagePath: AppImages.location),
              body(),
            ],
          ),
        ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          spacing: 10,
          children: [
            dataInsertField(),
            const Spacer(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget dataInsertField() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You Live with Your Family',
              style: TextStyle(
                fontSize: TextSize.font14(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
              List.generate(provider.isWithFamilyDataList.length, (index) {
                final isWithFamily = provider.isWithFamilyDataList[index];

                double screenWidth = MediaQuery.of(context).size.width - 40;
                double itemWidth = (screenWidth - 10) / 2;

                return SizedBox(
                  width: itemWidth,
                  child: SelectionCard(
                    buttonStyle: isWithFamily.isSelected
                        ? SelectionStyle.selectedRadio
                        : SelectionStyle.unSelectedRadio,
                    onTap: () {
                      provider.selectedIsWithFamily(index);
                    },
                    isSelected: isWithFamily.isSelected,
                    title: isWithFamily.name,
                  ),
                );
              }),
            ),
          ],
        ),
        DropDownField(
          headLine: 'Residency Status',
          hintText: 'Select',
          popUpHeader: 'Select Residency Status',
          items: provider.residencyStatusDropdownItems,
          controller: provider.residencyStatusController,
          // onTap: provider.loadLocationData,
          onConfirm: (value) => provider.onResidencyStatusSelected(value?.toString()),
          isSearch: true,
        ),
      ],
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Search Now',
      onTap: () {
   Navigator.pop(context);
      },
    );
  }
}
