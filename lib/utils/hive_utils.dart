import 'package:intl/intl.dart';

class HiveUtils {
  static String _getCurrentDate() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    return formattedDate;
  }

  static String getTodayUserStateKey() {
    String currentDate = _getCurrentDate();
    return "userState-$currentDate";
  }
}
