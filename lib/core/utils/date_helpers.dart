extension DateTimeParsing on DateTime {
  String toStringRemote() {
    return '$year-${month < 9 ? '0$month' : month}-${day < 9 ? '0$day' : day}';
  }
}
