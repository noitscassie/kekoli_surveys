class DateFormats {
  static ddmmyyyy(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class DurationFormats {
  static hoursAndMinutes(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes - (hours * Duration.minutesPerHour);

    return '${hours > 0 ? '$hours ${hours == 1 ? 'hour' : 'hours'} and ' : ''}$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }
}
