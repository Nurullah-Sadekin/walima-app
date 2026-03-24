import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/gradient_background.dart';
import 'package:flutter_boilerplate/core/global/components/primary_textField.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/router/route_name.dart';
import 'package:flutter_boilerplate/core/global/components/upper_layer.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/setting_switcher_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/registration/presentation/providers/registration_provider.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/loading_widget.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:go_router/go_router.dart';

class NewFilterScreen extends ConsumerStatefulWidget {
  const NewFilterScreen({super.key});
  @override
  ConsumerState<NewFilterScreen> createState() => _NewFilterScreenState();
}

class _NewFilterScreenState extends ConsumerState<NewFilterScreen> {
  late SearchFilterProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ref.read(searchFilterProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(searchFilterProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const CustomBackAppBar(title: Text('Refine'),backgroundColor: Colors.transparent,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
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


  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            personalizeYourSearch(),
          ],
        ),
      ),
    );
  }

  Widget personalizeYourSearch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headLineText('Personalize Your Search',
              fontSize: TextSize.font16(context)),
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
    );
  }


  Widget headLineText(String text, {double? fontSize}) {
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
