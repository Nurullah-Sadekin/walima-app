import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/global/enums/enums.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';

/// Religion is a static enum shared with web — it is NOT a lookup category on
/// the API (`GET /lookups?categorySlug=religion` returns nothing). These tests
/// pin mobile to the web definition so the two clients cannot drift again.
///
/// Web source of truth: `walima-frontend/src/enums/index.ts`
///   export const Religion = z.enum([
///     'open_to_all', 'islam', 'hinduism', 'christianity', 'buddhism', 'others'
///   ])
void main() {
  group('Religion enum web parity', () {
    test('api values match the web enum exactly, in the same order', () {
      expect(
        Religion.values.map((item) => item.apiValue).toList(),
        <String>[
          'open_to_all',
          'islam',
          'hinduism',
          'christianity',
          'buddhism',
          'others',
        ],
      );
    });

    test('labels match what web renders via enumToOptions', () {
      // enumToOptions() title-cases each underscore-separated word, so
      // `open_to_all` renders as "Open To All" on both clients.
      expect(
        Religion.values.map((item) => item.label).toList(),
        <String>[
          'Open To All',
          'Islam',
          'Hinduism',
          'Christianity',
          'Buddhism',
          'Others',
        ],
      );
    });

    test('religionLookupOptions mirrors the enum', () {
      expect(
        religionLookupOptions.map((item) => item.key).toList(),
        Religion.values.map((item) => item.apiValue).toList(),
      );
      expect(
        religionLookupOptions.map((item) => item.label).toList(),
        Religion.values.map((item) => item.label).toList(),
      );
    });
  });

  group('religionHasCommunityOptions', () {
    test('is false for the religions with no community category', () {
      // Confirmed against the live API: both return an empty `data` array.
      expect(religionHasCommunityOptions('open_to_all'), isFalse);
      expect(religionHasCommunityOptions('others'), isFalse);
    });

    test('is true for the religions the lookups API serves communities for', () {
      for (final slug in <String>[
        'islam',
        'hinduism',
        'christianity',
        'buddhism',
      ]) {
        expect(religionHasCommunityOptions(slug), isTrue, reason: slug);
      }
    });

    test('normalizes casing and whitespace', () {
      expect(religionHasCommunityOptions(' Islam '), isTrue);
      expect(religionHasCommunityOptions('OPEN_TO_ALL'), isFalse);
    });

    test('is false for empty or missing input', () {
      expect(religionHasCommunityOptions(null), isFalse);
      expect(religionHasCommunityOptions(''), isFalse);
      expect(religionHasCommunityOptions('   '), isFalse);
    });
  });
}
