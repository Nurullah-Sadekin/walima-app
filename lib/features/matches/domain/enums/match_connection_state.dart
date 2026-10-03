enum MatchConnectionState {
  none('none'),
  requested('requested'),
  received('received'),
  accepted('accepted'),
  declined('declined'),
  cancelled('cancelled'),
  blocked('blocked'),
  expired('expired');

  const MatchConnectionState(this.apiValue);

  final String apiValue;

  bool get canConnect =>
      this == MatchConnectionState.none ||
      this == MatchConnectionState.cancelled ||
      this == MatchConnectionState.expired;
}

MatchConnectionState normalizeMatchConnectionState(
  String? raw, {
  String? direction,
}) {
  switch (raw?.trim().toLowerCase()) {
    case 'accept':
    case 'accepted':
      return MatchConnectionState.accepted;
    case 'reject':
    case 'rejected':
    case 'declined':
      return MatchConnectionState.declined;
    case 'cancel':
    case 'cancelled':
    case 'canceled':
      return MatchConnectionState.cancelled;
    case 'block':
    case 'blocked':
      return MatchConnectionState.blocked;
    case 'pending':
      return direction?.trim().toLowerCase() == 'received'
          ? MatchConnectionState.received
          : MatchConnectionState.requested;
    case 'expired':
      return MatchConnectionState.expired;
    default:
      return MatchConnectionState.none;
  }
}
