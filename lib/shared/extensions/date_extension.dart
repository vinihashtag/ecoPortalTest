import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  String get formattedyyyyMMddHHmmss => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);

  String get formatyyyyMMdd => DateFormat('yyyy-MM-dd').format(this);

  String get formatddMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  String get formatHHmm => DateFormat('HH:mm').format(this);

  String get formatHHmmss => DateFormat('HH:mm:ss').format(this);

  String get formatddMMyyyyHHmmss => DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
}
