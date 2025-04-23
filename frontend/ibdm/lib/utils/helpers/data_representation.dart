import 'package:flutter/widgets.dart';

class DataRepresentation<T> {
  final String name;
  final String code;
  final IconData? icon;
  Map<String, T>? source;
  final T Function(dynamic value)? transform;
  final dynamic Function(Map<String, T> sourceObject)? toValue;
  DataRepresentation({
    required this.name,
    required this.code,
    this.source,
    this.transform,
    this.toValue,
    this.icon,
  });
  get value {
    if (source == null) {
      return null;
    }
    if (toValue == null) {
      return transform != null
          ? transform!.call(source![code] as dynamic)
          : source![code];
    } else {
      return transform != null
          ? transform!.call(toValue!(source as Map<String, T>))
          : toValue!(source as Map<String, T>);
    }
  }
}
