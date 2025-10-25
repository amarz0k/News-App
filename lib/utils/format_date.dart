import 'package:intl/intl.dart';

String formatDate(String dateStr) {
  final date = DateTime.parse(dateStr);
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 8) {
    // For older dates, return formatted date instead
    return DateFormat('MMM d, yyyy').format(date);
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return 'a day ago';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return 'an hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return 'a minute ago';
  } else {
    return 'just now';
  }
}
