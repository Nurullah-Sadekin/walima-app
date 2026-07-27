import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/home/data/model/response/profile_strength_response.dart';
import 'package:walima_llc/features/home/presentation/models/profile_strength_view_data.dart';

void main() {
  test('groups and stably orders profile strength sections', () {
    final data = ProfileStrengthData(
      overallScore: 71,
      sections: <ProfileStrengthSection>[
        _section('location', weight: 5, completed: false),
        _section('photos', weight: 15, completed: true),
        _section('religion', weight: 5, completed: false),
        _section('preferences', weight: 20, completed: false),
        _section('contact', weight: 2, completed: true),
      ],
      tips: const <String>['one', 'two'],
    );

    final viewData = ProfileStrengthViewData.fromDomain(data);

    expect(
      viewData.incomplete.map((section) => section.key),
      <String>['preferences', 'location', 'religion'],
    );
    expect(
      viewData.completed.map((section) => section.key),
      <String>['photos', 'contact'],
    );
    expect(viewData.overallScore, 71);
    expect(viewData.tips, <String>['one', 'two']);
  });
}

ProfileStrengthSection _section(
  String key, {
  required double weight,
  required bool completed,
}) {
  return ProfileStrengthSection(
    key: key,
    label: key,
    weight: weight,
    score: completed ? weight : 0,
    completionPercentage: completed ? 100 : 0,
    completed: completed,
    fields: const <ProfileStrengthField>[],
  );
}
