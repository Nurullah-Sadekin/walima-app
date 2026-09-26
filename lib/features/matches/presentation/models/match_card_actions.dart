import 'package:walima_llc/features/matches/data/models/response/get_matches_response.dart';
import 'package:walima_llc/features/matches/domain/enums/match_connection_state.dart';

class MatchCardActions {
  MatchCardActions(this.match, {required this.isShortlisted});

  final MatchProfile match;
  final bool isShortlisted;

  bool get isConnected =>
      match.connectionState == MatchConnectionState.accepted;
  bool get hasProfileId => match.id?.trim().isNotEmpty ?? false;
  bool get canConnect => !isConnected && hasProfileId && match.canConnect;
  bool get showPrimaryButton => hasProfileId && (isConnected || canConnect);
  bool get showSecondaryButton => isConnected
      ? hasProfileId
      : (match.id ?? match.userReference)?.trim().isNotEmpty ?? false;
  String get primaryLabel => isConnected ? 'Message' : 'Connect';
  String get secondaryLabel => isConnected
      ? 'Contact'
      : isShortlisted
          ? 'Shortlisted'
          : 'Shortlist';
}
