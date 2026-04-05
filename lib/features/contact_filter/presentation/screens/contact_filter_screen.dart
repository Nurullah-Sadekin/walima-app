import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/contact_filter/presentation/providers/contact_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactFilterScreen extends ConsumerStatefulWidget {
  const ContactFilterScreen({super.key});

  @override
  ConsumerState<ContactFilterScreen> createState() => _ContactFilterScreenState();
}

class _ContactFilterScreenState extends ConsumerState<ContactFilterScreen> {
  late ContactFilterProvider provider;
  FilterStep _step = FilterStep.contactFilterScreen;

  @override
  void initState() {
    super.initState();
    provider = ref.read(contactFilterProvider);
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(contactFilterProvider);

    return PopScope(
      canPop: _step == FilterStep.contactFilterScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step != FilterStep.contactFilterScreen) {
          setState(() => _step = FilterStep.contactFilterScreen);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _body(provider),
          ),
        ),
        floatingActionButton: BottomBorderedWidget(widget: bottomAction(provider)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomBackAppBar(
      title: Text(_step == FilterStep.contactFilterScreen ? 'Contact Filter' : _getAppBarTitle(_step)),
      backgroundColor: Colors.transparent,
      onBackPressed: () {
        if (_step != FilterStep.contactFilterScreen) {
          setState(() => _step = FilterStep.contactFilterScreen);
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  String _getAppBarTitle(FilterStep step) {
    switch (step) {
      case FilterStep.contactFilterScreen:
        return 'Refine';
      case FilterStep.ageRange:
        return 'Age Range';
      case FilterStep.heightRange:
        return 'Height Range';
      case FilterStep.maritalStatus:
        return 'Marital Status';
      case FilterStep.religion:
        return 'Religion';
      case FilterStep.community:
        return 'Community';
      case FilterStep.motherTongue:
        return 'Mother Tongue';
      case FilterStep.countryLivingIn:
        return 'Country Living In';
      case FilterStep.workingWith:
        return 'Working With';
      case FilterStep.annualIncome:
      return 'Annual Income';
    }
  }

  Widget _body(ContactFilterProvider provider) {
    switch (_step) {
      case FilterStep.contactFilterScreen:
        return _contactFilterBody(provider);
      case FilterStep.ageRange:
        return _ageRange(provider);
      case FilterStep.heightRange:
       return _heightRange(provider);
      case FilterStep.maritalStatus:
        return _maritalStatusBody(provider);
      case FilterStep.religion:
         return _religionBody(provider);
      case FilterStep.community:
        return _communityBody(provider);
      case FilterStep.motherTongue:
        return _motherTongueBody(provider);
      case FilterStep.countryLivingIn:
        return _countryBody(provider);
      case FilterStep.workingWith:
        return _workingWithBody(provider);
      case FilterStep.annualIncome:
        return _annualIncomeBody(provider);
    }
  }

  Widget _contactFilterBody(ContactFilterProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          const SizedBox(height: 6),
          InfoTile(
            title: 'Age Range',
            value: _singleSelectedName(provider.selectedCountries, '20 -26'),
            onTap: () => setState(() => _step = FilterStep.ageRange),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.calendarSvgIcon,
          ),
          InfoTile(
            title: 'Height Range',
            value: _singleSelectedName(provider.selectedCountries, '5\'0" - 6\'0" '),
            onTap: () => setState(() => _step = FilterStep.heightRange),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.heightSvgIcon,
          ),
          InfoTile(
            title: 'Marital Status',
            value: _multiSelectedNames(provider.selectedMaritalStatus, 'Open to All'),
            onTap: () => setState(() => _step = FilterStep.maritalStatus),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.weddingSvgIcon,
          ),
          InfoTile(
            title: 'Religion',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.religion),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.quranSvgIcon,
          ),
          InfoTile(
            title: 'Community',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.community),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.groupsIcon,
          ),

          InfoTile(
            title: 'Mother Tongue',
            value: _multiSelectedNames(provider.selectedMotherTongues, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.motherTongue),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.languageSvgIcon,
          ),
          InfoTile(
            title: 'Country Living In',
            value: _singleSelectedName(provider.selectedCountries, 'Bangladesh'),
            onTap: () => setState(() => _step = FilterStep.countryLivingIn),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.locationSvgIcon,
          ),

          InfoTile(
            title: 'Working With',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.workingWith),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.workSvgIcon,
          ),

          InfoTile(
            title: 'Annual Income',
            value: _multiSelectedNames(provider.selectedCommunities, 'Multiple Selected'),
            onTap: () => setState(() => _step = FilterStep.annualIncome),
            trailingImagePath: AppImages.editWrite,
            leadingImagePath: AppImages.propertySvgIcon,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _ageRange(ContactFilterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text('Age Range: ${provider.ageStart} to  ${provider.ageEnd} Years',
          style:  TextStyle(fontSize: TextSize.font16(context), color: AppColors.textPrimaryLight, fontWeight: FontWeight.w500)
          ),
        Text('Select a 2-year minimum age range',
          style:  TextStyle(fontSize: TextSize.font12(context), color: AppColors.textSecondaryLight, fontWeight: FontWeight.w400)
        ),
        const SizedBox(height: 16),
        _StyledRangeSlider(
          values: RangeValues(
            provider.ageStart.toDouble(),
            provider.ageEnd.toDouble(),
          ),
          min: provider.ageMinLimit.toDouble(),
          max: provider.ageMaxLimit.toDouble(),
          divisions: provider.ageMaxLimit - provider.ageMinLimit,
          startLabel: '${provider.ageStart}',
          endLabel: '${provider.ageEnd}',
          onChanged: provider.setAgeRange,
        ),

      ],
    );
  }

  Widget _heightRange(ContactFilterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text('Height Range: ${provider.heightStart} to  ${provider.heightEnd} cm',
          style:  TextStyle(fontSize: TextSize.font16(context), color: AppColors.textPrimaryLight, fontWeight: FontWeight.w500)
          ),
        Text('Select a 4-inch minimum height range',
          style:  TextStyle(fontSize: TextSize.font12(context), color: AppColors.textSecondaryLight, fontWeight: FontWeight.w400)
        ),
        const SizedBox(height: 16),
        _StyledRangeSlider(
          values: RangeValues(
            provider.heightStart.toDouble(),
            provider.heightEnd.toDouble(),
          ),
          min: provider.heightMinLimit.toDouble(),
          max: provider.heightMaxLimit.toDouble(),
          divisions: provider.heightMaxLimit - provider.heightMinLimit,
          startLabel: _formatHeight(provider.heightStart),
          endLabel: _formatHeight(provider.heightEnd),
          onChanged: provider.setHeightRange,
        ),
      ],
    );
  }

  Widget _maritalStatusBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.maritalStatusList,
          (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleMaritalStatus(index)),
    );
  }

  Widget _religionBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.maritalStatusList,
          (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleMaritalStatus(index)),
    );
  }

  Widget _communityBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.communities,
          (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleCommunity(index)),
    );
  }

  Widget _motherTongueBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.motherTongues,
          (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleMotherTongue(index)),
    );
  }

  Widget _countryBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.countries,
      (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleCountry(index)),
    );
  }

  Widget _workingWithBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.countries,
      (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleCountry(index)),
    );
  }

  Widget _annualIncomeBody(ContactFilterProvider provider) {
    return _wrapSelection(
      provider.motherTongues,
          (index) => _runSectionAction(() => ref.read(contactFilterProvider).toggleMotherTongue(index)),
    );
  }

  Widget _wrapSelection(List<dynamic> items, void Function(int index) onTap) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return SelectionCard(
            buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
            onTap: () => onTap(index),
            isSelected: item.isSelected,
            title: item.name,
            isExpand: true,
          );
        }),
      ),
    );
  }

  void _runSectionAction(VoidCallback action) {
    action();
    if (mounted) setState(() {});
  }

  Widget bottomAction(ContactFilterProvider provider) {
    if (_step == FilterStep.contactFilterScreen) {
      return PrimaryButtons(
        buttonStyle: ButtonsStyle.activePrimaryButton,
        title: 'Show Matches',
        onTap: () {
        },
      );
    }

    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Save Changes',
      onTap: () => setState(() => _step = FilterStep.contactFilterScreen),
    );
  }

  String _singleSelectedName(List<String> items, String fallback) {
    return items.isEmpty ? fallback : items.first;
  }

  String _multiSelectedNames(List<String> items, String fallback) {
    return items.isEmpty ? fallback : items.join(', ');
  }

  static String _formatHeight(int heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\"";
  }
}

enum FilterStep {
  contactFilterScreen,
  ageRange,
  heightRange,
  maritalStatus,
  religion,
  community,
  motherTongue,
  countryLivingIn,
  workingWith,
  annualIncome,
}

class _StyledRangeSlider extends StatelessWidget {
  const _StyledRangeSlider({
    required this.values,
    required this.min,
    required this.max,
    required this.startLabel,
    required this.endLabel,
    required this.onChanged,
    this.divisions,
  });

  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final String startLabel;
  final String endLabel;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 20.0;
    const thumbDiameter = 22.0;
    const sliderTop = 34.0;
    final availableWidth =
        MediaQuery.of(context).size.width - 40 - (horizontalPadding * 2);
    final startFactor = ((values.start - min) / (max - min)).clamp(0.0, 1.0);
    final endFactor = ((values.end - min) / (max - min)).clamp(0.0, 1.0);
    final startLeft = (availableWidth * startFactor) - 22;
    final endLeft = (availableWidth * endFactor) - 22;

    return SizedBox(
      height: 74,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: horizontalPadding + startLeft,
            top: 0,
            child: IgnorePointer(
              child: _SliderBubble(label: startLabel),
            ),
          ),
          Positioned(
            left: horizontalPadding + endLeft,
            top: 0,
            child: IgnorePointer(
              child: _SliderBubble(label: endLabel),
            ),
          ),
          Positioned.fill(
            top: sliderTop,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: const Color(0xFFF0F0F0),
                overlayShape: SliderComponentShape.noOverlay,
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                thumbColor: Colors.white,
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                rangeThumbShape: const _RingRangeThumbShape(
                  thumbRadius: thumbDiameter / 2,
                ),
              ),
              child: RangeSlider(
                values: values,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderBubble extends StatelessWidget {
  const _SliderBubble({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(18, 10),
          painter: _BubblePointerPainter(),
        ),
      ],
    );
  }
}

class _BubblePointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingRangeThumbShape extends RangeSliderThumbShape {
  const _RingRangeThumbShape({required this.thumbRadius});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        bool isDiscrete = false,
        bool isEnabled = false,
        bool isOnTop = false,
        required SliderThemeData sliderTheme,
        TextDirection textDirection = TextDirection.ltr,
        Thumb thumb = Thumb.start,
        bool isPressed = false,
      }) {
    final canvas = context.canvas;
    final outerPaint = Paint()..color = Colors.white;
    final innerPaint = Paint()..color = AppColors.primary;

    canvas.drawCircle(center, thumbRadius, outerPaint);
    canvas.drawCircle(center, thumbRadius - 7, innerPaint);
  }
}

