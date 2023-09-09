extension DateTimeExtension on DateTime {
  String getWeekDay () {
    List<String> weekDaysInStr = ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'];
    return weekDaysInStr[weekday - 1];
  }

  getMonth () {
    List<String> monthsInStr = ['Января', 'Февраля','Марта', 'Апреля','Мая','Июня','Июля','Августа','Сентября','Октября','Ноября','Декабря'];
    return monthsInStr[month];
  }

  String formatDateTime() {
    String hour = this.hour.toString().padLeft(2, '0');
    String minute = this.minute.toString().padLeft(2, '0');
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString();

    return "$hour:$minute $day.$month.$year";
  }

  String formatDateTimeForMessageItem() {
    String hour = this.hour.toString().padLeft(2, '0');
    String minute = this.minute.toString().padLeft(2, '0');
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString();

    String prefix ='$day $month в';

    final now = DateTime.now();
    final dif = difference(now).inDays;
    if(dif <= 1) {
      prefix = dif == 0  ?'Сегодня в' : 'Вчера в';
    }

    return "$prefix $hour:$minute";
  }
}