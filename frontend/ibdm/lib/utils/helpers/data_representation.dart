class DataRepresentation<T> {
  final String name;
  final String code;
  Map<String, T>? source;
  DataRepresentation({
    required this.name,
    required this.code,
    this.source,
  });
  get value => source?[code];
}
