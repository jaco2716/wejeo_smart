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

  // TuyaDevice.fromJson(Map<String, dynamic> json)
  //     : name = json['name'] as String,
  //       devId = json['devId'] as String,
  //       isOnline = json['isOnline'] as String,
  //       deviceType = json['deviceType'] as String,
  //       dps = json['dps'] as Map<String,dynamic>,
  //       homeId = json['homeId'] as String,
  //       roomId = json['roomId'] as String;

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'devId': devId,
  //       'isOnline': isOnline,
  //       'deviceType': deviceType,
  //       'dps': dps,
  //       'homeId': homeId,
  //       'roomId': roomId,
  //     };
}
