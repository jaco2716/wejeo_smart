// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuya_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TuyaDevice _$TuyaDeviceFromJson(Map<String, dynamic> json) => TuyaDevice(
      name: json['name'] as String,
      devId: json['devId'] as String,
      isOnline: json['isOnline'] as bool,
      isCloudOnline: json['isCloudOnline'] as bool,
      onlineType: json['onlineType'] as int,
      deviceType: json['deviceType'] as int,
      dps: json['dps'] == null
          ? {}
          : TuyaDevice._dpsFromJson(json['dps'] as String),
      homeId: json['homeId'] as int,
      roomId: json['roomId'] as int,
    );

Map<String, dynamic> _$TuyaDeviceToJson(TuyaDevice instance) =>
    <String, dynamic>{
      'name': instance.name,
      'devId': instance.devId,
      'isOnline': instance.isOnline,
      'isCloudOnline': instance.isCloudOnline,
      'onlineType': instance.onlineType,
      'deviceType': instance.deviceType,
      'dps': instance.dps,
      'homeId': instance.homeId,
      'roomId': instance.roomId,
    };
