import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';

class ProfileStrengthViewData {
  ProfileStrengthViewData.fromDomain(ProfileStrengthData data)
      : overallScore = data.overallScore,
        incomplete = _stableIncompleteSort(data.sections),
        completed = data.sections
            .where((section) => section.completed)
            .toList(growable: false),
        tips = List<String>.unmodifiable(data.tips);

  final int overallScore;
  final List<ProfileStrengthSection> incomplete;
  final List<ProfileStrengthSection> completed;
  final List<String> tips;

  static List<ProfileStrengthSection> _stableIncompleteSort(
    List<ProfileStrengthSection> sections,
  ) {
    final indexed = sections
        .asMap()
        .entries
        .where((entry) => !entry.value.completed)
        .toList(growable: false)
      ..sort((a, b) {
        final byWeight = b.value.weight.compareTo(a.value.weight);
        return byWeight != 0 ? byWeight : a.key.compareTo(b.key);
      });
    return List<ProfileStrengthSection>.unmodifiable(
      indexed.map((entry) => entry.value),
    );
  }
}
