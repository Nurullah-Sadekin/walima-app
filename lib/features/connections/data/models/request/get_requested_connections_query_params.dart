class GetRequestedConnectionsQueryParams {
  GetRequestedConnectionsQueryParams({
    this.page,
    this.size,
    this.sortBy,
    this.sortOrder,
    this.filter,
    this.extraParams,
  });

  final int? page;
  final int? size;
  final String? sortBy;
  final String? sortOrder;
  final String? filter;
  final Map<String, dynamic>? extraParams;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    void addValue(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (value is List && value.isEmpty) return;
      map[key] = value;
    }

    addValue('page', page);
    addValue('size', size);
    addValue('sortBy', sortBy);
    addValue('sortOrder', sortOrder);
    addValue('filter', filter);
    extraParams?.forEach(addValue);

    return map;
  }
}
