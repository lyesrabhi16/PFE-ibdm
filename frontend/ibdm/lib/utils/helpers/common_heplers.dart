import 'dart:math';
import 'package:shadcn_ui/shadcn_ui.dart';

String fromBytesToHumanReadableSize(int bytes) {
  if (bytes <= 0) return '0 Bytes';
  const List<String> suffixes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}

String dateTimeRangeToString(DateTime? start, DateTime? end,
    {bool includeTime = false}) {
  final formatted =
      "${start != null ? DateFormat(includeTime ? 'dd/MM/yyyy HH:mm' : 'dd/MM/yyyy').format(start) : ''}${end != null ? ' - ${DateFormat(includeTime ? 'dd/MM/yyyy HH:mm' : 'dd/MM/yyyy').format(end)}' : ''}";
  return formatted;
}

String getUniqueId() {
  final random = Random();
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789*-_+=!@#\$%^&*()';
  return List.generate(
      10, (index) => characters[random.nextInt(characters.length)]).join();
}
