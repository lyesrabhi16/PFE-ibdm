import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

printMessage(String message) {
  if (kReleaseMode) {
    return;
  } else {
    return;
    print(message);
  }
}
