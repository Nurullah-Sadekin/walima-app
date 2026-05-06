import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/features/registration/domain/single_string_model.dart';

class NewFilterProvider extends BaseChangeNotifier {
  NewFilterProvider();

  // Use existing list data from SingleStringModel lists
  List<SingleStringModel> countries = List.from(countryListDataInserted);
  List<SingleStringModel> communities = List.from(communityListDataInserted);

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
  List<String> get selectedCommunities => communities.where((c) => c.isSelected).map((e) => e.name).toList();

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

