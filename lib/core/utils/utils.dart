import 'package:intl/intl.dart';

class Utils {
  static String currency(double amount) => '\$${amount.toStringAsFixed(2)}';

  static String toIDR(double amount) {
    final formatter = NumberFormat.decimalPattern('en_US');
    return 'Rp. ${formatter.format(amount)}';
  }

  static String formatDateIndonesian(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  static int getRandomDistinctColor() {
    final colors = [
      0xFFE57373, // Red
      0xFF64B5F6, // Blue
      0xFF81C784, // Green
    ];
    colors.shuffle();
    return colors.first;
  }

  static String getMonthName(int month) {
    const monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return month >= 1 && month <= 12 ? monthNames[month - 1] : '';
  }

  static List<String> getListMonthNames() {
    return [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
  }

  static List<String> getListDaysName() {
    return ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  }

  static bool isSameMonth(date, DateTime month) {
    if (date is DateTime) {
      return date.year == month.year && date.month == month.month;
    }
    return false;
  }

  static double sumList(List<double> list) {
    return list.fold(0.0, (sum, item) => sum + item);
  }

  static String currencySuffix(double value) {
    final absValue = value.abs();
    String result;
    if (absValue >= 1e9) {
      result = '${(absValue / 1e9).toStringAsFixed(1)} M';
    } else if (absValue >= 1e6) {
      result = '${(absValue / 1e6).toStringAsFixed(1)} jt';
    } else if (absValue >= 1e3) {
      result = '${(absValue / 1e3).toStringAsFixed(1)} rb';
    } else {
      result = absValue.toInt().toString();
    }
    return value < 0 ? '-$result' : result;
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} detik yang lalu';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit yang lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam yang lalu';
    } else if (diff.inDays < 30) {
      return '${diff.inDays} hari yang lalu';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }
}
