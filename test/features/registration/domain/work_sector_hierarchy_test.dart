import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/domain/work_sector_hierarchy.dart';

void main() {
  group('WorkSectorHierarchy', () {
    test('returns only top-level categories as roots', () {
      const hierarchy = WorkSectorHierarchy(<LookupOption>[
        LookupOption(key: 'employed', label: 'Employed'),
        LookupOption(
            key: 'public', label: 'Public sector', parentKey: 'employed'),
        LookupOption(
            key: 'private', label: 'Private sector', parentKey: 'employed'),
        LookupOption(key: 'business', label: 'Business'),
      ]);

      expect(hierarchy.roots.map((option) => option.key),
          <String>['employed', 'business']);
      expect(hierarchy.childrenOf('employed').map((option) => option.key),
          <String>['public', 'private']);
    });

    test('treats a flat legacy response as selectable roots', () {
      const hierarchy = WorkSectorHierarchy(<LookupOption>[
        LookupOption(key: 'business', label: 'Business'),
        LookupOption(key: 'not_working', label: 'Not working'),
      ]);

      expect(hierarchy.roots, hasLength(2));
      expect(hierarchy.childrenOf('business'), isEmpty);
    });
  });
}
