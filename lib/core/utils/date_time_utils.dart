import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '--';
    try {
      return DateFormat('dd MMM, h:mm a').format(dateTime.toLocal());
    } catch (_) {
      return '--';
    }
  }
}