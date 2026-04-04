
class Filter {
  Filter({
    required this.value,
    required this.label,
    this.isSelected = false
  });

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

List<Filter> filterDataList = [
  Filter(value: 'most_relevant', label: 'Most Relevant'),
  Filter(value: 'newest_first', label: 'Newest First'),
  Filter(value: 'oldest_first', label: 'Oldest First'),
  Filter(value: 'all_requests', label: 'All Requests'),
  Filter(value: 'premium_members', label: 'Premium Members'),
  Filter(value: 'phone_verified_members', label: 'Phone Verified Members'),
];

List<Filter> sortDataList = [
  Filter(value: 'ASC', label: 'Ascending'),
  Filter(value: 'DESC', label: 'Descending'),
];

