import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:walima_llc/features/contact_filter/presentation/providers/contact_filter_provider.dart';
import 'package:walima_llc/features/matches/presentation/widgets/bottom_bordered_widget.dart';
import 'package:walima_llc/features/matches/presentation/widgets/into_tile.dart';
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
  final TextEditingController _communitySearchController =
      TextEditingController();
  final TextEditingController _motherTongueSearchController =
      TextEditingController();
  final TextEditingController _countrySearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    provider = ref.read(contactFilterProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadInitialData();
    });
  }

  @override
  void dispose() {
    _communitySearchController.dispose();
    _motherTongueSearchController.dispose();
    _countrySearchController.dispose();
    super.dispose();
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
        floatingActionButton: BottomBorderedWidget(widget: _bottomAction()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomBackAppBar(
      title: Text(
        (_step == ContactFilterStep.contactFilterScreen
                ? 'Contact Filter'
                : _getAppBarTitle(_step))
            .localized(context),
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
        return _selectionBody(
          items: provider.maritalStatusOptions,
          onTap: provider.toggleMaritalStatus,
        );
      case ContactFilterStep.religion:
        return _selectionBody(
          items: provider.religionOptions,
          onTap: provider.toggleReligion,
        );
      case ContactFilterStep.community:
        return _selectionBody(
          items: provider.communityOptions,
          onTap: provider.toggleCommunity,
          helperText: provider.religionOptions.every((item) => !item.isSelected)
              ? 'Select religion first to load community options.'
              : null,
          searchController: _communitySearchController,
          searchHintText: 'Search community',
        );
      case ContactFilterStep.motherTongue:
        return _selectionBody(
          items: provider.motherTongueOptions,
          onTap: provider.toggleMotherTongue,
          searchController: _motherTongueSearchController,
          searchHintText: 'Search mother tongue',
        );
      case ContactFilterStep.countryLivingIn:
        return _selectionBody(
          items: provider.countryOptions,
          onTap: provider.toggleCountryLivingIn,
          searchController: _countrySearchController,
          searchHintText: 'Search country',
        );
      case ContactFilterStep.workingWith:
        return _selectionBody(
          items: provider.workingWithOptions,
          onTap: provider.toggleWorkingWith,
        );
      case ContactFilterStep.annualIncome:
        return _selectionBody(
          items: provider.annualIncomeOptions,
          onTap: provider.toggleAnnualIncome,
        );
    }
  }

  Widget _contactFilterBody(ContactFilterProvider provider) {
    if (provider.isRemoteFilterLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          if (provider.remoteFilterError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                provider.remoteFilterError!,
                style: TextStyle(
                  fontSize: TextSize.font12(context),
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          InfoTile(
            title: 'Age Range'.localized(context),
            value: provider.ageRangeSummary,
            onTap: () => setState(() => _step = ContactFilterStep.ageRange),
            leadingImagePath: AppImages.calendarSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Height Range'.localized(context),
            value: provider.heightRangeSummary,
            onTap: () => setState(() => _step = ContactFilterStep.heightRange),
            leadingImagePath: AppImages.heightSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Marital Status'.localized(context),
            value: provider.maritalStatusSummary,
            onTap: () =>
                setState(() => _step = ContactFilterStep.maritalStatus),
            leadingImagePath: AppImages.weddingSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Religion'.localized(context),
            value: provider.religionSummary,
            onTap: () => setState(() => _step = ContactFilterStep.religion),
            leadingImagePath: AppImages.quranSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Community'.localized(context),
            value: provider.communitySummary,
            onTap: () => setState(() => _step = ContactFilterStep.community),
            leadingImagePath: AppImages.groupsIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Mother Tongue'.localized(context),
            value: provider.motherTongueSummary,
            onTap: () => setState(() => _step = ContactFilterStep.motherTongue),
            leadingImagePath: AppImages.languageSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Country Living In'.localized(context),
            value: provider.countryLivingInSummary,
            onTap: () =>
                setState(() => _step = ContactFilterStep.countryLivingIn),
            leadingImagePath: AppImages.locationSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Working With',
            value: provider.workingWithSummary,
            onTap: () => setState(() => _step = ContactFilterStep.workingWith),
            leadingImagePath: AppImages.workSvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 8),
          InfoTile(
            title: 'Annual Income',
            value: provider.annualIncomeSummary,
            onTap: () => setState(() => _step = ContactFilterStep.annualIncome),
            leadingImagePath: AppImages.propertySvgIcon,
            showTrailingImage: false,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _selectionBody({
    required List<dynamic> items,
    required void Function(int) onTap,
    String? helperText,
    TextEditingController? searchController,
    String? searchHintText,
  }) {
    final filteredIndexes = _filterIndexes(
      items,
      searchQuery: searchController?.text ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (helperText != null) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              helperText.localized(context),
              style: TextStyle(
                fontSize: TextSize.font12(context),
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ] else
          const SizedBox(height: 12),
        if (searchController != null) ...[
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: (searchHintText ?? 'Search').localized(context),
              hintStyle: TextStyle(
                fontSize: TextSize.font16(context),
                color: AppColors.textSecondaryLight,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.textSecondaryLight,
                size: TextSize.font22(context),
              ),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
              filled: true,
              fillColor: AppColors.greyLight.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ] else
          const SizedBox(height: 0),
        Expanded(
          child: filteredIndexes.isEmpty
              ? Center(
                  child: Text(
                    'No matching items found'.localized(context),
                    style: TextStyle(
                      fontSize: TextSize.font14(context),
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: filteredIndexes.map((index) {
                      final item = items[index];
                      return SelectionCard(
                        buttonStyle: item.isSelected
                            ? SelectionStyle.selectedCheckbox
                            : SelectionStyle.unSelectedCheckbox,
                        onTap: () => onTap(index),
                        isSelected: item.isSelected,
                        title: item.name,
                        isExpand: true,
                      );
                    }).toList(growable: false),
                  ),
                ),
        ),
      ],
    );
  }

  List<int> _filterIndexes(
    List<dynamic> items, {
    required String searchQuery,
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return List<int>.generate(items.length, (index) => index);
    }

    final indexes = <int>[];
    for (var index = 0; index < items.length; index++) {
      final name = items[index].name.toString().trim().toLowerCase();
      if (name.contains(normalizedQuery)) {
        indexes.add(index);
      }
    }
    return indexes;
  }

  Widget _ageRange(ContactFilterProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          '${'Age Range'.localized(context)}: ${provider.ageStart} ${'to'.localized(context)} ${provider.ageEnd} ${'Years'.localized(context)}',
          style: TextStyle(
            fontSize: TextSize.font16(context),
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Select a 2-year minimum age range'.localized(context),
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
          '${'Height Range'.localized(context)}: ${ContactFilterProvider.formatHeight(provider.heightStart)} ${'to'.localized(context)} ${ContactFilterProvider.formatHeight(provider.heightEnd)}',
          style: TextStyle(
            fontSize: TextSize.font16(context),
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Select a 4-inch minimum height range'.localized(context),
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
      buttonStyle: (provider.isApplying || provider.isRemoteFilterLoading)
          ? ButtonsStyle.disableButton
          : ButtonsStyle.activePrimaryButton,
      title: 'Apply',
      onTap: () async {
        if (provider.isApplying || provider.isRemoteFilterLoading) return;
        if (_step != ContactFilterStep.contactFilterScreen) {
          setState(() => _step = ContactFilterStep.contactFilterScreen);
          return;
        }

        final response = await provider.applyContactFilters();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor:
                response.isSuccess ? AppColors.success : AppColors.error,
            content: Text(
              response.isSuccess
                  ? (response.message.isNotEmpty
                      ? response.message
                      : 'Contact filter updated')
                  : (response.message.isNotEmpty
                      ? response.message
                      : 'Unable to update contact filter'),
            ),
          ),
        );
      },
    );
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
