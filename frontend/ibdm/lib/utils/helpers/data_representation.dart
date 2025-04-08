class DataRepresentation<T> {
  final String name;
  final String code;
  Map<String, T>? source;
  final T Function(dynamic v)? transform;
  final dynamic Function(Map<String, T> v)? toValue;
  DataRepresentation({
    required this.name,
    required this.code,
    this.source,
    this.transform,
    this.toValue,
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
