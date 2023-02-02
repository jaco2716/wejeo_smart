// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tuya_smart_timer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TuyaSmartTimer _$TuyaSmartTimerFromJson(Map<String, dynamic> json) =>
    TuyaSmartTimer(
      timerId: json['timerId'] as String,
      aliasName: json['aliasName'] as String,
      dpsStatus: json['dpsStatus'] as bool,
      loops: json['loops'] as String,
      status: json['status'] as bool,
      time: json['time'] as String,
    );

Map<String, dynamic> _$TuyaSmartTimerToJson(TuyaSmartTimer instance) =>
    <String, dynamic>{
      'timerId': instance.timerId,
      'aliasName': instance.aliasName,
      'dpsStatus': instance.dpsStatus,
      'loops': instance.loops,
      'status': instance.status,
      'time': instance.time,
    };
