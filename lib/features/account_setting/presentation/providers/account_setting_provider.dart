import 'package:flutter_boilerplate/core/global/models/filter_model.dart';
import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class AccountSettingProvider extends BaseChangeNotifier {
  AccountSettingProvider();

  bool? autoRenew = false;
  bool? hideProfile = false;
  bool? shortlistAlerts = false;
  bool? premiumCalls = false;

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



  bool _isValidIndex(int index, int length) => index >= 0 && index < length;

  String? setTimelineValue(int index) {
    if (!_isValidIndex(index, timelineDataList.length)) return null;
    return timelineDataList[index].value;
  }

  String? setDeleteProfileStatus(int index) {
    if (!_isValidIndex(index, deleteProfileStatus.length)) return null;
    return deleteProfileStatus[index].value;
  }


}
