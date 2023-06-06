import 'package:intl/intl.dart';

class DateFormats {
  static ddmmyyyy(DateTime date) => DateFormat('dd/MM/y').format(date);

  static ddmmyyyyNoBreaks(DateTime date) => DateFormat('ddMMy').format(date);
}

class TimeFormats {
  static String hoursAndMinutesFromMinutes(int totalMinutes) {
    final hours = (totalMinutes ~/ Duration.minutesPerHour);
    final minutes = totalMinutes % Duration.minutesPerHour;

    return '${hours > 0 ? '$hours ${hours == 1 ? 'hour' : 'hours'} and ' : ''}$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  static String hmFromMinutes(int totalMinutes) {
    final hours = (totalMinutes ~/ Duration.minutesPerHour);
    final minutes = totalMinutes % Duration.minutesPerHour;

    return '${hours > 0 ? '$hours${hours == 1 ? 'hr ' : 'hrs '}' : ''}$minutes${minutes == 1 ? 'm' : 'm'}';
  }

  static String timeHoursAndMinutes(DateTime time) =>
      '${time.hour}:${_paddedTimePart(time.minute)}';

  static String timeMinutesAndSeconds(Duration duration) {
    final minutes =
        _paddedTimePart(duration.inMinutes.remainder(Duration.minutesPerHour));

    final seconds = _paddedTimePart(
        duration.inSeconds.remainder(Duration.secondsPerMinute));

    return '$minutes:$seconds';
  }

  static _paddedTimePart(int length) => length.toString().padLeft(2, '0');
}
