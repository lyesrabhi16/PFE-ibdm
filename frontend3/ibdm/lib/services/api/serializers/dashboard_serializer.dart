import 'package:json_annotation/json_annotation.dart';
part 'dashboard_serializer.g.dart';

@JsonSerializable()
class DashboardSerializer {
  const DashboardSerializer({
    required this.message,
  });

  factory DashboardSerializer.fromJson(Map<String, dynamic> json) =>
      _$DashboardSerializerFromJson(json);

  final String? message;

  Map<String, dynamic> toJson() => _$DashboardSerializerToJson(this);
}
