import 'package:intl/intl.dart';


String cleanMonthFormat(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('MM');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String cleanYearFormat(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

DateTime cleanDateFormat(){
  String convertedDate = new DateFormat("yyyy-MM-dd").format(today);
  var parsedDate = DateTime.parse(convertedDate);
  return parsedDate;
}

int getWeekNumber(DateTime date){
  int year = date.year;
  DateTime stateDate = DateTime(year,1,1);
  int weekday = stateDate.weekday;
  int days = date.difference(stateDate).inDays; 
  int week = ((weekday+days)/7).ceil();
  return week;
}

var today = DateTime.now();

var currentWeek = getWeekNumber(today);

var currentMonth = cleanMonthFormat(today.toString());

var currentYear = cleanYearFormat(today.toString());

var currentDate = cleanDateFormat();

final lastWeek = currentDate.subtract(Duration(days: 7));

final lastMonth = currentDate.subtract(Duration(days: 30));

