import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/config/text_responsive.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/selection_card.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class HobbiesInterestsCard extends StatelessWidget {

  const HobbiesInterestsCard({
    super.key,
    required this.dataList,
    required this.title,
    required this.onItemTap,
  });

  final List<SingleStringModel> dataList;
  final String title;
  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: TextSize.font13(context),
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: dataList.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return SelectionCard(
                  buttonStyle: item.isSelected
                      ? SelectionStyle.selectedItem
                      : SelectionStyle.unSelectedItem,
                  isSelected: item.isSelected,
                  onTap: () => onItemTap(index),
                  title: item.name,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}