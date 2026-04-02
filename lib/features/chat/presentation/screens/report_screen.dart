import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.userName});
  final String? userName;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final List<String> _reasons = [
    'Inappropriate content',
    'Spam or scam',
    'Harassment or hate speech',
    'Fake profile',
    'Other',
  ];
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<bool>.filled(_reasons.length, false);
  }

  void _onApply() {
    final selectedReasons = <String>[];
    for (var i = 0; i < _reasons.length; i++) {
      if (_selected[i]) selectedReasons.add(_reasons[i]);
    }

    // For now just show a simple confirmation and pop back
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Report submitted'),
        content: Text(selectedReasons.isEmpty
            ? 'No reason selected. We will still review the profile.'
            : 'Thanks. Reported for: ${selectedReasons.join(", ")}. Our team will review it.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))
        ],
      ),
    ).then((_) => Navigator.of(context).maybePop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomBackAppBar(
        title: Text('Report'),
        isBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Report ${widget.userName ?? "user"}',
                  style: TextStyle(
                    fontSize: TextSize.font16(context),
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () => setState(() => _selected[index] = !_selected[index]),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _selected[index],
                          onChanged: (v) => setState(() => _selected[index] = v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _reasons[index],
                            style: TextStyle(
                              fontSize: TextSize.font14(context),
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: _reasons.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimaryLight,
                        side: const BorderSide(color: AppColors.greyLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

