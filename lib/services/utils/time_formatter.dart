class TimeFormatter {
  static String withSeparator(DateTime date, {String sep = 'h'}) {
    final h = date.hour.toString();
    final m = date.minute.toString().padLeft(2, '0');
    return '$h$sep$m';
  }
}
