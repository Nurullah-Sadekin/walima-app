import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/constants/app_image.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/global/components/dropdown_field.dart';
import 'package:flutter_boilerplate/core/global/components/primary_button.dart';
import 'package:flutter_boilerplate/core/providers/providers.dart';
import 'package:flutter_boilerplate/features/contact_filter/presentation/providers/contact_filter_provider.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:flutter_boilerplate/features/matches/presentation/widgets/into_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactFilterScreen extends ConsumerStatefulWidget {
  const ContactFilterScreen({super.key});

  @override
  ConsumerState<ContactFilterScreen> createState() =>
      _ContactFilterScreenState();
}

class _ContactFilterScreenState extends ConsumerState<ContactFilterScreen> {
  late ContactFilterProvider provider;
  ContactFilterStep _step = ContactFilterStep.contactFilterScreen;

  @override
  void initState() {
    super.initState();
    provider = ref.read(contactFilterProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = ref.watch(contactFilterProvider);

    return PopScope(
      canPop: _step == ContactFilterStep.contactFilterScreen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _step != ContactFilterStep.contactFilterScreen) {
          setState(() => _step = ContactFilterStep.contactFilterScreen);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _body(provider),
          ),
        ),
        floatingActionButton: _step == ContactFilterStep.contactFilterScreen
            ? null
            : BottomBorderedWidget(widget: _bottomAction()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomBackAppBar(
      title: Text(
        _step == ContactFilterStep.contactFilterScreen
            ? 'Contact Filter'
            : _getAppBarTitle(_step),
      ),
      backgroundColor: Colors.transparent,
      onBackPressed: () {
        if (_step != ContactFilterStep.contactFilterScreen) {
          setState(() => _step = ContactFilterStep.contactFilterScreen);
        } else {
          Navigator.of(context).maybePop();
        }
      },
    );
  }

  String _getAppBarTitle(ContactFilterStep step) {
    switch (step) {
      case ContactFilterStep.contactFilterScreen:
        return 'Contact Filter';
      case ContactFilterStep.ageRange:
        return 'Age Range';
      case ContactFilterStep.heightRange:
        return 'Height Range';
      case ContactFilterStep.maritalStatus:
        return 'Marital Status';
      case ContactFilterStep.religion:
        return 'Religion';
      case ContactFilterStep.community:
        return 'Community';
      case ContactFilterStep.motherTongue:
        return 'Mother Tongue';
      case ContactFilterStep.countryLivingIn:
        return 'Country Living In';
      case ContactFilterStep.workingWith:
        return 'Working With';
      case ContactFilterStep.annualIncome:
        return 'Annual Income';
    }
  }

  Widget _body(ContactFilterProvider provider) {
    switch (_step) {
      case ContactFilterStep.contactFilterScreen:
        return _contactFilterBody(provider);
      case ContactFilterStep.ageRange:
        return _ageRange(provider);
      case ContactFilterStep.heightRange:
        return _heightRange(provider);
      case ContactFilterStep.maritalStatus:
        return _dropdownQuestion(
          headLine: 'Marital Status',
          header: 'Select Marital Status',
          items: provider.maritalStatusDropdownItems,
          controller: provider.maritalStatusController,
          onConfirm: (value) => provider.onMaritalStatusSelected(value?.toString()),
        );
      case ContactFilterStep.religion:
        return _dropdownQuestion(
          headLine: 'Religion',
          header: 'Select Religion',
          items: provider.religionDropdownItems,
          controller: provider.religionController,
          onTap: provider.loadInitialData,
          onConfirm: (value) => provider.onReligionSelected(value?.toString()),
        );
      case ContactFilterStep.community:
        return _dropdownQuestion(
          headLine: 'Community',
          header: 'Select Community',
          items: provider.communityDropdownItems,
          controller: provider.communityController,
          enabled: provider.religionController.text.trim().isNotEmpty,
          helperText: provider.religionController.text.trim().isEmpty
              ? 'Select religion first to load community options.'
              : null,
          onTap: provider.loadCommunityData,
          onConfirm: (value) => provider.onCommunitySelected(value?.toString()),
        );
      case ContactFilterStep.motherTongue:
        return _dropdownQuestion(
          headLine: 'Mother Tongue',
          header: 'Select Mother Tongue',
          items: provider.motherTongueDropdownItems,
          controller: provider.motherTongueController,
          onConfirm: (value) => provider.onMotherTongueSelected(value?.toString()),
        );
      case ContactFilterStep.countryLivingIn:
        return _dropdownQuestion(
          headLine: 'Country Living In',
          header: 'Select Country',
          items: provider.countryDropdownItems,
          controller: provider.countryLivingInController,
          onTap: provider.loadLocationData,
          onConfirm: (value) =>
              provider.onCountryLivingInSelected(value?.toString()),
        );
      case ContactFilterStep.workingWith:
        return _dropdownQuestion(
          headLine: 'Working With',
          header: 'Select Profession',
          items: provider.workingWithDropdownItems,
          controller: provider.workingWithController,
          onTap: provider.loadCareerLookupData,
          onConfirm: (value) => provider.onWorkingWithSelected(value?.toString()),
        );
      case ContactFilterStep.annualIncome:
        return _dropdownQuestion(
          headLine: 'Annual Income',
          header: 'Select Income Range',
          items: provider.annualIncomeDropdownItems,
          controller: provider.annualIncomeController,
          onTap: provider.loadCareerLookupData,
          onConfirm: (value) => provider.onAnnualIncomeSelected(value?.toString()),
        );
    }
  }

  Widget _contactFilterBody(ContactFilterProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          InfoTile(
            title: 'Age Range',
            value: provider.ageRangeSummary,
            onTap: () => setState(() => _step = ContactFilterStep.ageRange),
            leadingImagePath: AppImages.calendarSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Height Range',
            value: provider.heightRangeSummary,
            onTap: () => setState(() => _step = ContactFilterStep.heightRange),
            leadingImagePath: AppImages.heightSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Marital Status',
            value: _textOrFallback(
              provider.maritalStatusController.text,
              'Select',
            ),
            onTap: () => setState(() => _step = ContactFilterStep.maritalStatus),
            leadingImagePath: AppImages.weddingSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Religion',
            value: _textOrFallback(provider.religionController.text, 'Select'),
            onTap: () => setState(() => _step = ContactFilterStep.religion),
            leadingImagePath: AppImages.quranSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Community',
            value: _textOrFallback(provider.communityController.text, 'Select'),
            onTap: () => setState(() => _step = ContactFilterStep.community),
            leadingImagePath: AppImages.groupsIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Mother Tongue',
            value: _textOrFallback(
              provider.motherTongueController.text,
              'Select',
            ),
            onTap: () => setState(() => _step = ContactFilterStep.motherTongue),
            leadingImagePath: AppImages.languageSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Living In',
            value: _textOrFallback(
              provider.countryLivingInController.text,
              'Select',
            ),
            onTap: () =>
                setState(() => _step = ContactFilterStep.countryLivingIn),
            leadingImagePath: AppImages.locationSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Working With',
            value: _textOrFallback(provider.workingWithController.text, 'Select'),
            onTap: () => setState(() => _step = ContactFilterStep.workingWith),
            leadingImagePath: AppImages.workSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Annual Income',
            value: _textOrFallback(
              provider.annualIncomeController.text,
              'Select',
            ),
            onTap: () => setState(() => _step = ContactFilterStep.annualIncome),
            leadingImagePath: AppImages.propertySvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _dropdownQuestion({
    required String headLine,
    required String header,
    required List<String> items,
    required TextEditingController controller,
    Future<void> Function()? onTap,
    void Function(dynamic)? onConfirm,
    bool enabled = true,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (helperText != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              helperText,
              style: TextStyle(
                fontSize: TextSize.font12(context),
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        DropDownField(
          headLine: headLine,
          hintText: 'Select',
          popUpHeader: header,
          items: items,
          controller: controller,
          enabled: enabled,
          onTap: onTap,
          onConfirm: onConfirm,
          isSearch: true,
        ),
      ],
    );
  }

  Widget _ageRange(ContactFilterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          'Age Range: ${provider.ageStart} to ${provider.ageEnd} Years',
          style: TextStyle(
            fontSize: TextSize.font16(context),
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Select a 2-year minimum age range',
          style: TextStyle(
            fontSize: TextSize.font12(context),
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w400,
          ),
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
        Text(
          'Height Range: ${ContactFilterProvider.formatHeight(provider.heightStart)} to ${ContactFilterProvider.formatHeight(provider.heightEnd)}',
          style: TextStyle(
            fontSize: TextSize.font16(context),
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Select a 4-inch minimum height range',
          style: TextStyle(
            fontSize: TextSize.font12(context),
            color: AppColors.textSecondaryLight,
            fontWeight: FontWeight.w400,
          ),
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
          startLabel: ContactFilterProvider.formatHeight(provider.heightStart),
          endLabel: ContactFilterProvider.formatHeight(provider.heightEnd),
          onChanged: provider.setHeightRange,
        ),
      ],
    );
  }

  Widget _bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Apply',
      onTap: () {
        setState(() => _step = ContactFilterStep.contactFilterScreen);
      },
    );
  }

  String _textOrFallback(String value, String fallback) {
    final text = value.trim();
    return text.isEmpty ? fallback : text;
  }
}

enum ContactFilterStep {
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
