import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

extension WidgetRemoveWhen on Widget {
  Widget? removeWhen(bool condition) {
    return condition ? null : this;
  }
}

extension DataCellremoveWhen on DataCell {
  DataCell? removeWhen(bool condition) {
    return condition ? null : this;
  }
}

extension DataColumnremoveWhen on DataColumn2 {
  DataColumn2? removeWhen(bool condition) {
    return condition ? null : this;
  }
}
