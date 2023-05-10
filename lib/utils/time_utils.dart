import 'package:intl/intl.dart';

class DateFormats {
  static ddmmyyyy(DateTime date) => DateFormat('dd/MM/y').format(date);

  static ddmmyyyyNoBreaks(DateTime date) => DateFormat('ddMMy').format(date);
}

class TimeFormats {
  static hoursAndMinutesFromMinutes(int totalMinutes) {
    final hours = (totalMinutes ~/ Duration.minutesPerHour);
    final minutes = totalMinutes % Duration.minutesPerHour;

    return '${hours > 0 ? '$hours ${hours == 1 ? 'hour' : 'hours'} and ' : ''}$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  static hmFromMinutes(int totalMinutes) {
    final hours = (totalMinutes ~/ Duration.minutesPerHour);
    final minutes = totalMinutes % Duration.minutesPerHour;

    return '${hours > 0 ? '$hours${hours == 1 ? 'hr' : 'hr'}' : ''} $minutes${minutes == 1 ? 'm' : 'm'}';
  }

  static timeHoursAndMinutes(DateTime time) =>
      '${time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
}
