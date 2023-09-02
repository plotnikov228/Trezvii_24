extension DateTimeExtension on DateTime {
  String getWeekDay () {
    List<String> weekDaysInStr = ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'];
    return weekDaysInStr[weekday];
  }

  getMonth () {
    List<String> monthsInStr = ['Января', 'Февраля','Марта', 'Апреля','Мая','Июня','Июля','Августа','Сентября','Октября','Ноября','Декабря'];
    return monthsInStr[month];
  }
}