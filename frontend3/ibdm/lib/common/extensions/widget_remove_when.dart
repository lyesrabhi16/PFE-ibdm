import 'package:flutter/material.dart';

extension WidgetRemoveWhen on Widget {
  Widget? removeWhen(bool condition) {
    return condition ? null : this;
  }
}
