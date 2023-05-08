class DateFormats {
  static ddmmyyyy(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class TimeFormats {
  static hoursAndMinutesFromMinutes(int totalMinutes) {
    final hours = (totalMinutes ~/ Duration.minutesPerHour);
    final minutes = totalMinutes % Duration.minutesPerHour;

    return '${hours > 0 ? '$hours ${hours == 1 ? 'hour' : 'hours'} and ' : ''}$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  static timeHoursAndMinutes(DateTime time) =>
      '${time.hour}:${time.minute < 10 ? '0${time.minute}' : time.minute}';
}