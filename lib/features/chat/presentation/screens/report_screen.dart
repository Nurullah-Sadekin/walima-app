import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/global/components/custom_back_appbar.dart';
import 'package:walima_llc/core/global/components/selection_card.dart';
import 'package:walima_llc/core/router/route_name.dart';
import 'package:walima_llc/core/utils/localized_text.dart';
import 'package:go_router/go_router.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.userName});
  final String? userName;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

enum ReportStep { reasons, details }

class ReportReason {
  ReportReason({required this.reportType, this.isSelected = false});
  final String reportType;
  bool isSelected;
}

class _ReportScreenState extends State<ReportScreen> {
  final List<ReportReason> _reasons = [
    ReportReason(reportType: 'Fake / Misleading profile information'),
    ReportReason(reportType: 'Multiple profiles'),
    ReportReason(reportType: 'Phone number is incorrect'),
    ReportReason(reportType: 'Photos are fake or obscene'),
    ReportReason(reportType: 'Has sent abusive emails / chats'),
    ReportReason(reportType: 'Is already married / engaged'),
    ReportReason(reportType: 'Asking for money / scammer'),
    ReportReason(reportType: 'Not responding'),
    ReportReason(reportType: 'Other misuse reason'),
  ];

  static const double _spacing = 10;
  static const int _maxChars = 500;

  ReportStep _step = ReportStep.reasons;
  int? _activeIndex;
  final TextEditingController _detailsController = TextEditingController();
  final FocusNode _detailsFocusNode = FocusNode();

  @override
  void dispose() {
    _detailsController.dispose();
    _detailsFocusNode.dispose();
    super.dispose();
  }

  String get _title {
    // if (_step == ReportStep.details && _activeIndex != null) {
    //   return _reasons[_activeIndex!].reportType;
    // }
    return 'Report';
  }

  void _selectReason(int index) {
    setState(() {
      for (final reason in _reasons) {
        reason.isSelected = false;
      }
      _reasons[index].isSelected = true;
      _activeIndex = index;
      // stay on reasons step; the primary button moves to details
      _step = ReportStep.reasons;
      _detailsController.clear();
    });
  }

  void _goToDetails() {
    if (_activeIndex == null) return;
    setState(() {
      _step = ReportStep.details;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _detailsFocusNode.requestFocus();
    });
  }

  void _goBackToReasons() {
    setState(() {
      _step = ReportStep.reasons;
    });
  }

  void _onApply() {
    if (_activeIndex == null) return;

    context.pushNamed(
      Routes.reportStatus,
      extra: {
        'title': 'Report Successfully!',
        'subtitle':
            'Report submitted successfully. We’ll review it shortly. Thank you for reporting.',
        'buttonText': 'Done',
        'onTapButton': () {
          if (context.canPop()) {
            context.pop();
          }
          if (context.canPop()) {
            context.pop();
          }
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        title: Text(_title),
        isBackButton: true,
        onBackPressed: () {
          if (_step == ReportStep.details) {
            _goBackToReasons();
          } else {
            Navigator.of(context).maybePop();
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _body(),
        ),
      ),
      bottomNavigationBar: _bottomAction(),
    );
  }

  Widget _body() {
    switch (_step) {
      case ReportStep.reasons:
        return _reasonsBody();
      case ReportStep.details:
        return _detailsBody();
    }
  }

  Widget _reasonsBody() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: _spacing,
        runSpacing: _spacing,
        children: List.generate(_reasons.length, (index) {
          final item = _reasons[index];
          return SelectionCard(
            buttonStyle: item.isSelected
                ? SelectionStyle.selectedCheckbox
                : SelectionStyle.unSelectedCheckbox,
            onTap: () => _selectReason(index),
            isSelected: item.isSelected,
            title: item.reportType,
            isExpand: true,
          );
        }),
      ),
    );
  }

  Widget _detailsBody() {
    if (_activeIndex == null) return const SizedBox.shrink();

    final selectedReason = _reasons[_activeIndex!].reportType;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            selectedReason,
            style: TextStyle(
              fontSize: TextSize.font16(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _detailsController,
                focusNode: _detailsFocusNode,
                maxLines: 8,
                maxLength: _maxChars,
                decoration: const InputDecoration(
                  hintText: 'Details  section...',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondaryLight,
                  ),
                  border: InputBorder.none,
                  fillColor: AppColors.white,
                  filled: true,
                  focusColor: AppColors.white,
                  counterText: '',
                ),
                style: TextStyle(
                  color: AppColors.textPrimaryLight,
                  fontSize: TextSize.font14(context),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomAction() {
    final isDetails = _step == ReportStep.details;
    final canProceed = _activeIndex != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (isDetails) {
                  _goBackToReasons();
                } else {
                  Navigator.of(context).pop();
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimaryLight,
                side: const BorderSide(color: AppColors.greyLight),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text((isDetails ? 'Back' : 'Cancel').localized(context)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: !canProceed
                  ? null
                  : () {
                      if (_step == ReportStep.reasons) {
                        _goToDetails();
                      } else {
                        _onApply();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text((isDetails ? 'Apply' : 'Next').localized(context)),
            ),
          ),
        ],
      ),
    );
  }
}
