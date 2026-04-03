import 'package:flutter_boilerplate/core/providers/base_change_notifier.dart';
import 'package:flutter_boilerplate/features/registration/domain/single_string_model.dart';

class InboxProvider extends BaseChangeNotifier {
  bool? switcherValue = false;

  List<SingleStringModel> sortByDataList = sortByListDataInserted
      .map((item) => item.copyWith())
      .toList();

  void updateViewState({bool? switcherValue}) {
    if (switcherValue != null) {
      this.switcherValue = switcherValue;
    }
    notifyListeners();
  }

  bool _isValidIndex(int index, int length) {
    return index >= 0 && index < length;
  }

  void _setSingleSelection<T>(
    List<T> list,
    int selectedIndex,
    void Function(T item, bool selected) applySelection,
  ) {
    for (var i = 0; i < list.length; i++) {
      applySelection(list[i], i == selectedIndex);
    }
  }

  void sortBy(int index) {
    if (!_isValidIndex(index, sortByDataList.length)) return;
    _setSingleSelection(
      sortByDataList,
      index,
      (item, selected) => item.isSelected = selected,
    );
    notifyListeners();
  }
}

