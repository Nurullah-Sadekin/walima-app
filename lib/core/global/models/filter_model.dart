import 'package:walima_llc/core/global/enums/enums.dart';

class Filter {
  Filter({required this.value, required this.label, this.isSelected = false});

  final String value;
  final String label;
  bool isSelected;

  Filter copyWith({
    String? value,
    String? label,
    bool? isSelected,
  }) {
    return Filter(
      value: value ?? this.value,
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<Filter> buildInboxFilterDataList() {
  return InboxConnectionFilter.values.keyPairs
      .map(
        (item) => Filter(
          value: item.apiValue,
          label: item.uiValue,
        ),
      )
      .toList(growable: false);
}

List<Filter> filterDataList = buildInboxFilterDataList();

List<Filter> sortDataList = [
  Filter(value: 'ASC', label: 'Ascending'),
  Filter(value: 'DESC', label: 'Descending'),
];
