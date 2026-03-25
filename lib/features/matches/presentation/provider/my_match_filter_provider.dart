import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class MyMatchFilterProvider extends BaseChangeNotifier {
  MyMatchFilterProvider();

  // Toggleable lists
  List<SingleStringModel> countries = List.from(countryListDataInserted);
  List<SingleStringModel> communities = List.from(communityListDataInserted);
  List<SingleStringModel> motherTongues = [];

  // Simple toggles and dropdown-like selections stored as strings
  bool photoSettingOpenToAll = true;
  bool recentlyJoinedOpenToAll = true;
  bool activeMembersOpenToAll = true;
  String annualIncome = 'Open to All';
  List<String> maritalStatus = []; // multiple selected
  String religion = 'Muslim';
  List<String> motherTongueSelected = [];
  String countryLivingIn = 'Bangladesh';
  String stateLivingIn = 'Open to All';
  String countryGrewUpIn = 'Open to All';
  String educationLevel = 'Open to All';
  String educationArea = 'Open to All';
  String workingWith = 'Open to All';
  String professionArea = 'Open to All';
  String profileManagedBy = 'Open to All';
  String eatingHabits = 'Open to All';

  // Toggle methods
  void toggleCountry(int index) {
    if (index < 0 || index >= countries.length) return;
    countries[index].isSelected = !countries[index].isSelected;
    notifyListeners();
  }

  void toggleCommunity(int index) {
    if (index < 0 || index >= communities.length) return;
    communities[index].isSelected = !communities[index].isSelected;
    notifyListeners();
  }

  List<String> get selectedCountries => countries.where((c) => c.isSelected).map((e) => e.name).toList();
  List<String> get selectedCommunities => communities.where((c) => c.isSelected).map((e) => e.name).toList();

  void clearAll() {
    for (var c in countries) c.isSelected = false;
    for (var c in communities) c.isSelected = false;
    maritalStatus.clear();
    motherTongueSelected.clear();
    notifyListeners();
  }
}
