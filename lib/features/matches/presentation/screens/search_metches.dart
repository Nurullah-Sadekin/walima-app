import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_matches_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
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
  ConsumerState<SearchMatchesScreen> createState() =>
      _SearchMatchesScreenState();
}

class _SearchMatchesScreenState extends ConsumerState<SearchMatchesScreen> {
  late SearchMatchesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(searchMatchesProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(searchMatchesProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _appbar(),
              _body(),
            ],
          ),
        ),
      ),
      floatingActionButton: BottomBorderedWidget(
        widget: bottomAction(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _appbar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,
              size: TextSize.font16(context),
              color: AppColors.textSecondaryLight),
        ),
        Text(
          'Search Box',
          style: TextStyle(
            fontSize: TextSize.font16(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return Expanded(
      child: Column(
        spacing: 10,
        children: [
          personalizeYourSearch(),
          const SizedBox(height: 65),
        ],
      ),
    );
  }

  Widget personalizeYourSearch() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.greyLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headLineText('Personalize Your Search', fontSize: TextSize.font16(context)),
              SizedBox(height: TextSize.font16(context)),
              headLineText('Age'),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: DropDownField(
                      hintText: 'From',
                      popUpHeader: 'Age From',
                      items: provider.ageRangeDropdownItems,
                      controller: provider.ageFromController,
                    //  onConfirm: (value) => provider.onResidencyStatusSelected(value?.toString()),
                      isSearch: true,
                    ),
                  ),
                  Expanded(
                    child: DropDownField(
                      hintText: 'To',
                      popUpHeader: 'Age To',
                      items: provider.ageRangeDropdownItems,
                      controller: provider.ageToController,
                     // onConfirm: (value) => provider.onResidencyStatusSelected(value?.toString()),
                      isSearch: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Height'),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: DropDownField(
                      hintText: 'From',
                      popUpHeader: 'Height From',
                      items: provider.ageRangeDropdownItems,
                      controller: provider.heightFromController,
                      isSearch: true,
                    ),
                  ),
                  Expanded(
                    child: DropDownField(
                      hintText: 'To',
                      popUpHeader: 'Height To',
                      items: provider.ageRangeDropdownItems,
                      controller: provider.heightToController,
                      isSearch: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Marital Status'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Marital Status',
                items: provider.ageRangeDropdownItems,
                controller: provider.maritalStatusController,
                isSearch: true,
              ),


              SizedBox(height: TextSize.font12(context)),
              headLineText('Have Children'),
              SizedBox(height: TextSize.font10(context)),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: List.generate(provider.haveChildren.length, (index) {
                  final haveChildren = provider.haveChildren[index];

                  return SelectionCard(
                    buttonStyle: haveChildren.isSelected
                        ? SelectionStyle.selectedRadio
                        : SelectionStyle.unSelectedRadio,
                    onTap: () {
                      provider.selectedHaveChildren(index);
                    },
                    isSelected: haveChildren.isSelected,
                    title: haveChildren.name,
                    isExpand: false,
                  );
                }),
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Your Religion'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Your Religion',
                items: provider.ageRangeDropdownItems,
                controller: provider.religionController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Community'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Community',
                items: provider.ageRangeDropdownItems,
                controller: provider.communityController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Mother Tongue'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Mother Tongue',
                items: provider.ageRangeDropdownItems,
                controller: provider.motherTongueController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Country Living In'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Country Living In',
                items: provider.ageRangeDropdownItems,
                controller: provider.countryLivingController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('State Living In'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'State Living In',
                items: provider.ageRangeDropdownItems,
                controller: provider.stateLivingController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Country Grew Up In'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Country Grew Up In',
                items: provider.ageRangeDropdownItems,
                controller: provider.grewUpController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Residency Status'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Residency Status',
                items: provider.ageRangeDropdownItems,
                controller: provider.residencyStatusController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),
              headLineText('Photo Setting'),
              DropDownField(
                hintText: 'Select',
                popUpHeader: 'Photo Setting',
                items: provider.ageRangeDropdownItems,
                controller: provider.photoSettingController,
                isSearch: true,
              ),

              SizedBox(height: TextSize.font12(context)),

            ],
          ),
        ),
      ),
    );
  }

  Widget headLineText(String text,{double? fontSize}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? TextSize.font14(context),
        fontWeight: FontWeight.w500,
      ),
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
