enum MatchSortBy {
  relevance('relevance'),
  newest('newest'),
  lastActive('last_active'),
  ageAsc('age_asc'),
  ageDesc('age_desc');

  const MatchSortBy(this.apiValue);

  final String apiValue;

  static MatchSortBy fromLabel(String? label) {
    switch (label?.toLowerCase().trim()) {
      case 'newest first':
        return MatchSortBy.newest;
      case 'oldest first':
        return MatchSortBy.relevance;
      case 'last active':
        return MatchSortBy.lastActive;
      case 'age ascending':
        return MatchSortBy.ageAsc;
      case 'age descending':
        return MatchSortBy.ageDesc;
      case 'most relevant':
      default:
        return MatchSortBy.relevance;
    }
  }
}
