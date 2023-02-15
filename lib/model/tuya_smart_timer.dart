import 'package:json_annotation/json_annotation.dart';

part 'tuya_smart_timer.g.dart';

@JsonSerializable()
class TuyaSmartTimer {
  String timerId;
  String aliasName;
  bool dpsStatus;
  String loops;
  bool status;
  String time;

  TuyaSmartTimer({
    required this.timerId,
    required this.aliasName,
    required this.dpsStatus,
    required this.loops,
    required this.status,
    required this.time,
  });

  factory TuyaSmartTimer.fromJson(Map<String, dynamic> json) => _$TuyaSmartTimerFromJson(json);

  Map<String, dynamic> toJson() => _$TuyaSmartTimerToJson(this);

  @override
  String toString() {
    return "timerId: $timerId, aliasName: $aliasName, dpsStatus: $dpsStatus, loops: $loops, status: $status, time: $time";
  }
}
