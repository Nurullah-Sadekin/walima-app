enum MatchEducationLevel {
  openToAll('open_to_all'),
  highSchool('high_school'),
  bachelor('bachelor'),
  master('master'),
  phd('phd');

  const MatchEducationLevel(this.apiValue);

  final String apiValue;

  static MatchEducationLevel? fromLabel(String? label) {
    switch (label?.toLowerCase().trim()) {
      case 'open to all':
        return MatchEducationLevel.openToAll;
      case 'high school':
        return MatchEducationLevel.highSchool;
      case 'bachelor':
        return MatchEducationLevel.bachelor;
      case 'master':
        return MatchEducationLevel.master;
      case 'phd':
        return MatchEducationLevel.phd;
      default:
        return null;
    }
  }
}
