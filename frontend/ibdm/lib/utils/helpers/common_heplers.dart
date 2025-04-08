import 'dart:math';

String fromBytesToHumanReadableSize(int bytes) {
  if (bytes <= 0) return '0 Bytes';
  const List<String> suffixes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}
