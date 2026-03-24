import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/features/matches/presentation/provider/search_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';

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
    return  const Column(
      spacing: 10,
      children: [
        InfoTile(
            title: 'Country Living In',
            value: 'Bangladesh',
            onTap: null,
            trailingImagePath: AppImages.editWrite,
          leadingImagePath: AppImages.locationSvgIcon,
        ),
        InfoTile(
            title: 'Community',
            value: 'Bangladesh',
            onTap: null,
            trailingImagePath: AppImages.editWrite,
          leadingImagePath: AppImages.profileSvgIcon,
        ),
      ],
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
      title: 'Show Matches',
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
