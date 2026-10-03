import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/matches/data/models/request/get_matches_query_params.dart';

void main() {
  test('does not send open_to_all as a literal religion filter', () {
    final query = GetMatchesQueryParams(
      type: 'today',
      religion: 'open_to_all',
    ).toJson();

    expect(query, isNot(contains('religion')));
  });

  test('keeps an explicit religion filter', () {
    final query = GetMatchesQueryParams(
      type: 'today',
      religion: 'islam',
    ).toJson();

    expect(query['religion'], 'islam');
  });
}
