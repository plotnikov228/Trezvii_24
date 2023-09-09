extension DurationExtension on Duration {
  String calculateTimeBetweenDates() {
    Duration duration = this;

    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    String result = '';

    if (days > 0) {
      result += '$days день ';
    }

    if (hours > 0) {
      result += '$hours часов ';
    }

    if (minutes > 0) {
      result += '$minutes минут';
    }

    return result.trim();
  }
}