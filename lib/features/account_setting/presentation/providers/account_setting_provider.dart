import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/models/filter_model.dart';
import 'package:flutter_boilerplate/core/network/dio_client.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/account_setting/data/models/account_settings.dart';
import 'package:flutter_boilerplate/features/account_setting/data/repository/account_settings_repository.dart';

class AccountSettingProvider extends BaseChangeNotifier {
  AccountSettingProvider();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String newPasswordError = '';
  String confirmPasswordError = '';
  bool? autoRenew = false;
  bool? hideProfile = false;
  bool? shortlistAlerts = false;
  bool? premiumCalls = false;
  bool? autoMessageConnect = false;

  bool isAccountLoading = false;
  bool isAccountSaving = false;
  String? accountError;


  List<Filter> timelineDataList = [
    Filter(label: '1 Week', value: '1_week'),
    Filter(label: '2 Weeks', value: '2_weeks'),
    Filter(label: '1 Month', value: '1_month'),
    Filter(label: 'Until I turn on', value: 'until_i_turn_on'),
  ];
  List<Filter> deleteProfileStatus = [
    Filter(label: 'Taking a break', value: 'test'),
    Filter(label: 'Unsatisfactory experience', value: 'test'),
    Filter(label: 'Reason not mentioned here', value: 'test'),
  ];
  List<Filter> contactDisplayStatus = [
    Filter(label: 'Only Premium Members', value: 'test'),
    Filter(label: 'Only Premium Members you like', value: 'test'),
    Filter(label: 'No one (Matches won\'t be able to cal you)', value: 'test'),
    Filter(label: 'Only visible to all you Matches (Expires with Membership)', value: 'test'),
  ];



  bool _isValidIndex(int index, int length) => index >= 0 && index < length;

  String? setTimelineValue(int index) {
    if (!_isValidIndex(index, timelineDataList.length)) return null;
    return timelineDataList[index].value;
  }

  String? setDeleteProfileStatus(int index) {
    if (!_isValidIndex(index, deleteProfileStatus.length)) return null;
    return deleteProfileStatus[index].value;
  }

  Future<void> loadAccountSettings() async {
    isAccountLoading = true;
    accountError = null;
    notifyListeners();

    final response = await AccountSettingsRepository.getAccountSettings();

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      firstNameController.text = data.firstName ?? '';
      lastNameController.text = data.lastName ?? '';
      emailController.text = data.email ?? '';
    } else {
      accountError = response.message;
    }

    isAccountLoading = false;
    notifyListeners();
  }

  Future<ApiResponse> saveAccountSettings() async {
    isAccountSaving = true;
    notifyListeners();

    final settings = AccountSettings(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
    );

    final response =
        await AccountSettingsRepository.updateAccountSettings(settings);

    isAccountSaving = false;
    notifyListeners();

    return response;
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
