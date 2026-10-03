enum MatchMaritalStatus {
  openToAll('open_to_all'),
  neverMarried('never_married'),
  married('married'),
  divorced('divorced'),
  widowed('widowed'),
  separated('separated'),
  awaitingDivorce('awaiting_divorce'),
  annulled('annulled');

  const MatchMaritalStatus(this.apiValue);

  final String apiValue;

  static MatchMaritalStatus? fromLabel(String? label) {
    switch (label?.toLowerCase().trim()) {
      case 'open to all':
        return MatchMaritalStatus.openToAll;
      case 'never married':
        return MatchMaritalStatus.neverMarried;
      case 'married':
        return MatchMaritalStatus.married;
      case 'divorced':
        return MatchMaritalStatus.divorced;
      case 'widowed':
        return MatchMaritalStatus.widowed;
      case 'separated':
        return MatchMaritalStatus.separated;
      case 'awaiting divorce':
        return MatchMaritalStatus.awaitingDivorce;
      case 'annulled':
        return MatchMaritalStatus.annulled;
      default:
        return null;
    }
  }
}
