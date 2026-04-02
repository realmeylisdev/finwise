import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static final _fullDate = DateFormat('MMM dd, yyyy');
  static final _shortDate = DateFormat('MMM dd');
  static final _monthYear = DateFormat('MMMM yyyy');
  static final _time = DateFormat('HH:mm');

  static String fullDate(DateTime date) => _fullDate.format(date);
  static String shortDate(DateTime date) => _shortDate.format(date);
  static String monthYear(DateTime date) => _monthYear.format(date);
  static String time(DateTime date) => _time.format(date);

  static String relative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '${diff}d ago';
    return shortDate(date);
  }
}
