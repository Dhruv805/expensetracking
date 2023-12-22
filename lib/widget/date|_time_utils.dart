import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getFormattedDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy  hh:mm:ss');
    return formatter.format(dateTime);

  }static String getExpensesDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy  hh:mm');
    return formatter.format(dateTime);
  }

  static String getFormattedBirthDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  static String getFormattedDateBackSlash(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  static String getFormattedTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  static String getFormattedDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd:MM:yyyy');
    return formatter.format(dateTime);
  }

  static String getFormattedTimeOfAPi(String timeString) {
    final DateFormat apiTimeFormat = DateFormat('HH:mm');
    final DateTime dateTime = apiTimeFormat.parse(timeString);

    final DateFormat displayFormat = DateFormat('HH:mm');
    return displayFormat.format(dateTime);
  }
}
