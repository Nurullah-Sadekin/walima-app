part of 'profile_section_edit_screen.dart';

extension _ProfileSectionEditUiFormFieldsPart
    on _ProfileSectionEditScreenState {
  Widget _buildCard({required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _withSpacing(children),
    );
  }

  List<Widget> _withSpacing(List<Widget> children) {
    final widgets = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      widgets.add(children[i]);
      if (i < children.length - 1) {
        widgets.add(const SizedBox(height: 10));
      }
    }
    return widgets;
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool datePicker = false,
    bool readOnly = false,
    int minLines = 1,
    int maxLines = 1,
    String? hintText,
    VoidCallback? onTap,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText ?? 'Enter $label',
      controller: controller,
      keyboardType: keyboardType,
      datePicker: datePicker,
      readOnly: readOnly,
      minLine: minLines,
      maxLine: maxLines,
      errorText: '',
      onTap: onTap ?? () {},
    );
  }

  Widget _multiLookupField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText,
      controller: controller,
      readOnly: true,
      errorText: '',
      noPrefix: true,
      onTap: onTap,
      suffix: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: TextSize.font20(context),
        color: AppColors.grey,
      ),
    );
  }

  Widget _pickerField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return PrimaryTextField(
      headLine: label,
      hintText: hintText,
      controller: controller,
      readOnly: true,
      enabled: enabled,
      errorText: '',
      noPrefix: true,
      onTap: onTap,
      suffix: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: TextSize.font20(context),
        color: AppColors.grey,
      ),
    );
  }

  Widget _multiSelectField({
    required String label,
    required List<SingleStringModel> options,
    required ValueChanged<int> onItemTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(options.length, (index) {
            final item = options[index];
            return SelectionCard(
              buttonStyle: item.isSelected
                  ? SelectionStyle.selectedCheckbox
                  : SelectionStyle.unSelectedCheckbox,
              onTap: () => onItemTap(index),
              isSelected: item.isSelected,
              title: item.name,
            );
          }),
        ),
      ],
    );
  }

  Widget _rangeSelector({
    required String label,
    required int startValue,
    required int endValue,
    required int min,
    required int max,
    required String startLabel,
    required String endLabel,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        _StyledRangeSlider(
          values: RangeValues(startValue.toDouble(), endValue.toDouble()),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          startLabel: startLabel,
          endLabel: endLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _multiTextSelectionField({
    required String label,
    required List<String> options,
    required List<String> selectedValues,
    required bool isLoading,
    required bool isLoadingMore,
    required String emptyText,
    required ValueChanged<String> onItemTap,
    VoidCallback? onLoadMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: TextSize.font14(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (options.isEmpty)
          Text(
            emptyText,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
              fontSize: TextSize.font13(context),
              fontWeight: FontWeight.w400,
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((value) {
              final isSelected = selectedValues.any(
                (item) => item.toLowerCase() == value.toLowerCase(),
              );
              return SelectionCard(
                buttonStyle: isSelected
                    ? SelectionStyle.selectedCheckbox
                    : SelectionStyle.unSelectedCheckbox,
                onTap: () => onItemTap(value),
                isSelected: isSelected,
                title: value,
              );
            }).toList(growable: false),
          ),
        if (isLoadingMore)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (onLoadMore != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextButton(
              onPressed: onLoadMore,
              child: Text('Load more'.localized(context)),
            ),
          ),
      ],
    );
  }
}
