// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuya_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TuyaHome _$TuyaHomeFromJson(Map<String, dynamic> json) => TuyaHome(
      name: json['name'] as String,
      homeId: json['homeId'] as int,
      geoName: json['geoName'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$TuyaHomeToJson(TuyaHome instance) => <String, dynamic>{
      'name': instance.name,
      'homeId': instance.homeId,
      'geoName': instance.geoName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
