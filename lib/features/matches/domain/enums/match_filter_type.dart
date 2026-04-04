enum MatchFilterType {
  openToAll('open_to_all'),
  twoWayMatches('two_way_matches');

  const MatchFilterType(this.apiValue);

  final String apiValue;
}
