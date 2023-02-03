import 'package:json_annotation/json_annotation.dart';

part 'tuya_home.g.dart';

@JsonSerializable()
class TuyaHome {
  String name;
  int homeId;
  String geoName;
  double latitude;
  double longitude;

  TuyaHome({
    required this.name,
    required this.homeId,
    this.geoName = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  factory TuyaHome.fromJson(Map<String, dynamic> json) => _$TuyaHomeFromJson(json);

  Map<String, dynamic> toJson() => _$TuyaHomeToJson(this);
}
