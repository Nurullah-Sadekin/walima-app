const int recentVisitorsFreeAllowance = 2;

bool isRecentVisitorLocked({
  required bool? hasFeature,
  required int page,
  required int size,
  required int indexOnPage,
}) {
  if (hasFeature != false) return false;
  final globalIndex = ((page - 1) * size) + indexOnPage;
  return globalIndex >= recentVisitorsFreeAllowance;
}
