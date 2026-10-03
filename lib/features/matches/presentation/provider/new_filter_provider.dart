import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/registration/data/models/lookup_option.dart';
import 'package:walima_llc/features/registration/data/repository/lookup_repository.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class NewFilterProvider extends BaseChangeNotifier {
  NewFilterProvider();

  final LookupRepository _lookupRepository = LookupRepository();

  // Use existing list data from SingleStringModel lists
  List<SingleStringModel> countries = List.from(countryListDataInserted);

  /// This screen has no religion step, so it shows the union of every religion's
  /// communities from `GET /lookups?categorySlug={religion}` rather than a
  /// hardcoded list.
  List<SingleStringModel> communities = <SingleStringModel>[];
  bool isCommunityLoading = false;

  Future<void> loadCommunityData() async {
    if (isCommunityLoading || communities.isNotEmpty) return;

    final slugs = religionLookupOptions
        .map((item) => item.key)
        .where(religionHasCommunityOptions)
        .toList(growable: false);

    isCommunityLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait<List<LookupOption>>(
        slugs.map((slug) => _lookupRepository.getLookupsBySlug(slug)),
      );

      final merged = <String, SingleStringModel>{};
      for (final result in results) {
        for (final option in result) {
          merged[option.key] =
              SingleStringModel(name: option.label, value: option.key);
        }
      }

      communities = merged.values.toList(growable: false);
    } catch (_) {
      communities = <SingleStringModel>[];
    } finally {
      isCommunityLoading = false;
      notifyListeners();
    }
  }

  // Toggle selection for country (multi-select)
  void toggleCountry(int index) {
    if (index < 0 || index >= countries.length) return;
    countries[index].isSelected = !countries[index].isSelected;
    notifyListeners();
  }

  // Toggle selection for community (multi-select)
  void toggleCommunity(int index) {
    if (index < 0 || index >= communities.length) return;
    communities[index].isSelected = !communities[index].isSelected;
    notifyListeners();
  }

  // Get list of selected names
  List<String> get selectedCountries => countries.where((c) => c.isSelected).map((e) => e.name).toList();

  /// Lookup keys — what the API matches on.
  List<String> get selectedCommunities =>
      communities.where((c) => c.isSelected).map((e) => e.value ?? e.name).toList();

  /// Display labels for summary rows.
  List<String> get selectedCommunityLabels =>
      communities.where((c) => c.isSelected).map((e) => e.name).toList();

  // Clear selections
  void clearAll() {
    for (var c in countries) {
      c.isSelected = false;
    }
    for (var c in communities) {
      c.isSelected = false;
    }
    notifyListeners();
  }
}
