import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/global/components/gradient_background.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/features/recommended_preferences/presentation/providers/recommended_preferences_provider.dart';
import 'package:walima_llc/core/global/components/upper_layer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walima_llc/core/global/components/primary_button.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/global/components/loading_widget.dart';
import 'package:walima_llc/core/providers/providers.dart';
import 'package:go_router/go_router.dart';

class BasicDetailsScreen extends ConsumerStatefulWidget {
  const BasicDetailsScreen({super.key});
  @override
  ConsumerState<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends ConsumerState<BasicDetailsScreen> {
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
                  isBackButton: true,
                  isTrailing: true,
                  trailingText: 'Skip',
                  onTrailingTap: null),
              body(),
            ],
          ),
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
            view(),
            bottomAction(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget view() {
    return Expanded(
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Age Range',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
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
          const SizedBox(height: 18),
          Text(
            'Height Range',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
            ),
          ),
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
          Text(
            'Martial Status',
            style: TextStyle(
              fontSize: TextSize.font14(context),
              fontWeight: FontWeight.w500,
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
                      children: List.generate(provider.maritalStatusDataList.length, (index) {
                        final item = provider.maritalStatusDataList[index];

                        return SelectionCard(
                          buttonStyle: item.isSelected
                              ? SelectionStyle.selectedCheckbox
                              : SelectionStyle.unSelectedCheckbox,
                          onTap: () {
                            provider.toggleMaritalStatus(index);
                          },
                          isSelected: item.isSelected,
                          title: item.name,
                        );
                      }),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAction() {
    return PrimaryButtons(
      buttonStyle: ButtonsStyle.activePrimaryButton,
      title: 'Continue',
      onTap: () {
        context.push(Paths.community);
      },
    );
  }

  static String _formatHeight(int heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\"";
  }
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
