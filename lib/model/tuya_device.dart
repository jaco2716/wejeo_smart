import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'tuya_device.g.dart';

@JsonSerializable()
class TuyaDevice {
  String name;
  String devId;
  bool isOnline;
  bool isCloudOnline;
  int onlineType;
  int deviceType;

  @JsonKey(defaultValue: {}, fromJson: _dpsFromJson)
  Map<String, dynamic> dps;

  int homeId;
  int roomId;

  TuyaDevice({
    required this.name,
    required this.devId,
    required this.isOnline,
    required this.isCloudOnline,
    required this.onlineType,
    required this.deviceType,
    required this.dps,
    required this.homeId,
    required this.roomId,
  });

  static Map<String, dynamic> _dpsFromJson(String value) => jsonDecode(value);

  factory TuyaDevice.fromJson(Map<String, dynamic> json) => _$TuyaDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$TuyaDeviceToJson(this);
}
