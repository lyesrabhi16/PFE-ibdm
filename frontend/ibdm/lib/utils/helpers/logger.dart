import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

void printMessage(String message) {
  if (kDebugMode) {
    printMessage(message);
  }
}
