import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class AccountSettingProvider extends BaseChangeNotifier {
  AccountSettingProvider();

  bool? autoRenew = false;

  final List<SingleStringModel> premiumMembershipOptions = [
    SingleStringModel(
      name: 'Show premium badge on profile',
      isSelected: true,
    ),
    SingleStringModel(
      name: 'Send membership renewal reminder',
      isSelected: true,
    ),
    SingleStringModel(
      name: 'Receive premium offer updates',
    ),
  ];

  final List<SingleStringModel> contactPrivacyOptions = [
    SingleStringModel(
      name: 'Show phone number to accepted matches only',
      isSelected: true,
    ),
    SingleStringModel(
      name: 'Hide WhatsApp contact from public profile',
      isSelected: true,
    ),
    SingleStringModel(
      name: 'Allow contact requests before approval',
    ),
  ];

  final List<SingleStringModel> verificationBadgeOptions = [
    SingleStringModel(
      name: 'Display verification badge publicly',
      isSelected: true,
    ),
    SingleStringModel(
      name: 'Prioritize verified profiles in suggestions',
    ),
    SingleStringModel(
      name: 'Notify me when verification expires',
      isSelected: true,
    ),
  ];

  final List<SingleStringModel> dateOfBirthOptions = [
    SingleStringModel(name: 'Show full date of birth'),
    SingleStringModel(
      name: 'Show month and year only',
      isSelected: true,
    ),
    SingleStringModel(name: 'Hide date of birth'),
  ];

  final List<SingleStringModel> messageOptions = [
    SingleStringModel(
      name: 'Everyone can message me',
    ),
    SingleStringModel(
      name: 'Matches only can message me',
      isSelected: true,
    ),
    SingleStringModel(
      name: 'Turn on message read receipts',
      isSelected: true,
    ),
  ];

  final List<SingleStringModel> deleteProfileOptions = [
    SingleStringModel(name: 'Deactivate profile for now'),
    SingleStringModel(name: 'Delete profile permanently'),
  ];

  void togglePremiumMembershipOption(int index) {
    _toggleSelection(premiumMembershipOptions, index);
  }

  void toggleContactPrivacyOption(int index) {
    _toggleSelection(contactPrivacyOptions, index);
  }

  void toggleVerificationBadgeOption(int index) {
    _toggleSelection(verificationBadgeOptions, index);
  }

  void selectDateOfBirthOption(int index) {
    _selectSingle(dateOfBirthOptions, index);
  }

  void toggleMessageOption(int index) {
    _toggleSelection(messageOptions, index);
  }

  void selectDeleteProfileOption(int index) {
    _selectSingle(deleteProfileOptions, index);
  }

  String get premiumMembershipSummary =>
      _selectedSummary(premiumMembershipOptions);

  String get contactPrivacySummary => _selectedSummary(contactPrivacyOptions);

  String get verificationBadgeSummary =>
      _selectedSummary(verificationBadgeOptions);

  String get dateOfBirthSummary =>
      _selectedSummary(dateOfBirthOptions, fallback: 'Not set');

  String get messageSummary => _selectedSummary(messageOptions);

  String get deleteProfileSummary =>
      _selectedSummary(deleteProfileOptions, fallback: 'Not selected');

  Map<String, dynamic> buildResult() {
    return {
      'premiumMembership': _selectedNames(premiumMembershipOptions),
      'contactPrivacy': _selectedNames(contactPrivacyOptions),
      'verificationBadge': _selectedNames(verificationBadgeOptions),
      'dateOfBirth': _selectedNames(dateOfBirthOptions),
      'message': _selectedNames(messageOptions),
      'deleteProfile': _selectedNames(deleteProfileOptions),
    };
  }

  void clearDeleteProfileSelection() {
    for (final option in deleteProfileOptions) {
      option.isSelected = false;
    }
    notifyListeners();
  }

  void _toggleSelection(List<SingleStringModel> list, int index) {
    if (index < 0 || index >= list.length) return;
    list[index].isSelected = !list[index].isSelected;
    notifyListeners();
  }

  void _selectSingle(List<SingleStringModel> list, int index) {
    if (index < 0 || index >= list.length) return;
    for (var i = 0; i < list.length; i++) {
      list[i].isSelected = i == index;
    }
    notifyListeners();
  }

  List<String> _selectedNames(List<SingleStringModel> list) {
    return list.where((item) => item.isSelected).map((item) => item.name).toList();
  }

  String _selectedSummary(
    List<SingleStringModel> list, {
    String fallback = 'Not selected',
  }) {
    final selected = _selectedNames(list);
    if (selected.isEmpty) return fallback;
    if (selected.length == 1) return selected.first;
    return '${selected.length} selected';
  }
}
