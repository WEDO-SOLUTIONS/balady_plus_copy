
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:intl/intl.dart';

class WeatherDateFormatter {
  // static String defaultLocale =
  //     Platform.localeName; // Returns locale string in the form 'en_US

  //get today day
  static String getToday() {
    final DateTime now = DateTime.now();
    return DateFormat('EEEE', 'ar').format(now);
  }

  static String getDay(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE', 'ar').format(dateTime);
  }

  static String getAlertDay(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return CommonFunctions.replaceArabicNumberWithEnglish(
        DateFormat('EEEE, dd/MM/yyyy hh:mm a', 'ar').format(dateTime));
  }

  static bool isToday(String date) {
    if (getToday() == getDay(date)) {
      return true;
    } else {
      return false;
    }
  }
}
