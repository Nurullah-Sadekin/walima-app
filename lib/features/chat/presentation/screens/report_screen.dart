import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.userName});
  final String? userName;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class ReportItem {
  ReportItem({required this.name, this.isSelected = false});
  final String name;
  bool isSelected;
}

class _ReportScreenState extends State<ReportScreen> {
   List<ReportItem> _items = [];
  static const double spacing = 10.0;

  @override
  void initState() {
    super.initState();
    _items = [
      ReportItem(name: 'Fake/ Misleading profile information'),
      ReportItem(name: 'Multiple profiles'),
      ReportItem(name: 'Phone number is incorrect'),
      ReportItem(name: 'Photos are fake or obscene'),
      ReportItem(name: 'Has sent abusive Emails / Chats'),
      ReportItem(name: 'Is already married / Engaged'),
      ReportItem(name: 'Asking for money / Scammer'),
      ReportItem(name: 'Not Responding'),
      ReportItem(name: 'Other misuse reason'),
    ];
  }

  void _onApply() {
    final selectedReasons = _items.where((i) => i.isSelected).map((e) => e.name).toList();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              return SelectionCard(
                buttonStyle: item.isSelected ? SelectionStyle.selectedCheckbox : SelectionStyle.unSelectedCheckbox,
                onTap: () => setState(() => _items[index].isSelected = !_items[index].isSelected),
                isSelected: item.isSelected,
                title: item.name,
                isExpand: true,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _bottomAction(){
    return Padding(
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
    );
  }
}
