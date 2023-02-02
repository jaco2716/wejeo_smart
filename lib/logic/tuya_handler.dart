import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wejeo_smart/model/tuya_device.dart';
import 'package:wejeo_smart/model/tuya_smart_timer.dart';

class TuyaHandler extends ChangeNotifier {
  static const _methodChannel = MethodChannel('dk.wejeo.wejeoSmart/tuya');

  ///
  /// Get a list of homes as Json objects (Map<String, dynamic>)
  ///
  /// Home model values:
  /// * `"name"` : String? The name of the Home
  /// * `"homeId"` : Int The id of the Home
  /// * `"geoName"` : String? The location of the Home
  /// * `"latitude"` : Double The latitude of the Home
  /// * `"longitude"` : Double The longitude of the Home
  ///
  Future<List<Map<String, dynamic>>?> getHomeList() async {
    try {
      var result = await _methodChannel.invokeMethod<String?>('getHomeList');
      // print('result:');
      // print('$result');
      List<dynamic> resultList = [];
      if (result != null) {
        resultList = jsonDecode(result);
      }
      List<Map<String, dynamic>> mapResult = resultList.map((e) => e as Map<String, dynamic>).toList();

      return mapResult;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<int> addHome(
    String homeName,
    String geoName,
    String roomName,
    double lat,
    double lon,
    void Function(int homeId) successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'homeName': homeName,
        'geoName': geoName,
        'roomName': roomName,
        'lat': lat,
        'lon': lon,
      };
      final int result = await _methodChannel.invokeMethod('addHome', args);
      successCallback(result);
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error: $e');
      return -1;
    }
  }

  Future<void> removeHome(
    int homeId,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      var result = await _methodChannel.invokeMethod<String?>('removeHome', homeId);
      if (result == 'Success') {
        successCallback();
      } else {
        errorCallback('$result, try again.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error: $e');
    }
  }

  Future<String?> getWifiName() async {
    try {
      String? ssid;
      final NetworkInfo networkInfo = NetworkInfo();
      //var status =
      await Permission.location.request();
      // print(status);

      ssid = await networkInfo.getWifiName();

      return ssid;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<bool?> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<void> startParing(
    String ssid,
    String password,
    // int mode,
    void Function(String deviceId) successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      int? currentHomeId = await getCurrentHome();
      Map<String, dynamic> args = {
        'homeId': currentHomeId,
        'password': password, //'JJ20120902','749dfd196',
        'ssid': ssid, //'Schmidt2',
        'mode': 0,
      };
      // print(args);
      String result = await _methodChannel.invokeMethod('startParing', args);
      var resultList = result.split(':');
      if (resultList.length > 1) {
        if (resultList[0] == 'Success') {
          successCallback(resultList[1]);
        } else {
          errorCallback('$result, try again.');
        }
      } else {
        errorCallback('$result, try again.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error paring: $e');
    }
  }

  Future<void> stopParing() async {
    try {
      await _methodChannel.invokeMethod('stopParing');
      // print("Stopped Paring");
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> setCurrentHome(int homeId) async {
    try {
      await _methodChannel.invokeMethod('setCurrentHome', homeId);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<int?> getCurrentHome() async {
    try {
      int? currentHomeId = await _methodChannel.invokeMethod('getCurrentHome');
      return currentHomeId;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  ///
  /// Get a list of devices as Json objects (Map<String, dynamic>) under current home
  ///
  /// Device model values:
  /// * `"name"` : String? The name of the Home
  /// * `"devId"` : String? The id of the Home
  /// * `"isOnline"` : bool Indicates whether a device is online.
  /// * `"dps"` : Map<String, dynamic>? The data points (DPs) of a device.
  /// * `"deviceType"` : Enum? The type of device.
  /// * `"homeId"` : int The ID of the home that a device belongs to.
  /// * `"roomId"` : int The ID of the room that a device belongs to.
  ///
  Future<List<Map<String, dynamic>>?> getCurrentHomeDeviceList() async {
    try {
      // Map<String, dynamic>? result = await platform.invokeMethod('getCurrentHomeDeviceList');
      var result = await _methodChannel.invokeMethod<String?>('getCurrentHomeDeviceList');
      List<dynamic> resultList = [];
      if (result != null) {
        resultList = jsonDecode(result);
      }
      List<Map<String, dynamic>> mapResult = resultList.map((e) => e as Map<String, dynamic>).toList();
      return mapResult;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getDeviceListFromHomeId(int homeId) async {
    try {
      // Map<String, dynamic>? result = await platform.invokeMethod('getCurrentHomeDeviceList');
      var result = await _methodChannel.invokeMethod<String?>('getDeviceListFromHomeId', homeId);
      List<dynamic> resultList = [];
      if (result != null) {
        resultList = jsonDecode(result);
      }
      List<Map<String, dynamic>> mapResult = resultList.map((e) => e as Map<String, dynamic>).toList();
      return mapResult;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<void> modifyDeviceName(
    String deviceId,
    String name,
    void Function(String message) successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'deviceId': deviceId,
        'name': name,
      };
      var result = await _methodChannel.invokeMethod<String?>('modifyDeviceName', args);
      if (result == 'Success') {
        successCallback("Device has been removed");
      } else {
        errorCallback('$result, try again.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error removing device: $e.');
    }
  }

  Future<bool?> setDeviceValue(String deviceId, String dpId) async {
    try {
      Map<String, dynamic> args = {
        'deviceId': deviceId,
        'dpId': dpId,
      };
      var result = await _methodChannel.invokeMethod<bool?>('setDeviceValue', args);
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> readDeviceValues(String deviceId, String dpId) async {
    try {
      var result = await _methodChannel.invokeMethod<String?>('readDeviceValues', deviceId);
      Map<String, dynamic> resultMap = {};
      if (result != null) {
        resultMap = jsonDecode(result);
        // print(resultMap);
      }
      return resultMap;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Stream<TuyaDevice>? deviceValueStream(String devId) {
    try {
      _methodChannel.invokeMethod<String?>('setCurrentDevice', devId);
      const deviceEventChannel = EventChannel('dk.wejeo.wejeoSmart/deviceEvents');
      final networkStream = deviceEventChannel.receiveBroadcastStream().distinct().map((dynamic event) => TuyaDevice.fromJson(jsonDecode(event)));

      return networkStream;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  ///
  /// Get a Stream of the home devices dps updates
  ///
  /// Device model values:
  /// * `"name"` : String? The name of the Home
  /// * `"devId"` : String? The id of the Home
  /// * `"isOnline"` : bool Indicates whether a device is online.
  /// * `"dps"` : Map<String, dynamic>? The data points (DPs) of a device.
  /// * `"deviceType"` : Enum? The type of device.
  /// * `"homeId"` : int The ID of the home that a device belongs to.
  /// * `"roomId"` : int The ID of the room that a device belongs to.
  ///
  Stream<List<TuyaDevice>>? homeDevicesValueStream() {
    try {
      const deviceEventChannel = EventChannel('dk.wejeo.wejeoSmart/homeEvents');
      final networkStream = deviceEventChannel
          .receiveBroadcastStream()
          .distinct()
          .map((dynamic event) => (jsonDecode(event ?? '[]') as List<dynamic>).map((e) => TuyaDevice.fromJson(e)).toList());
      // deviceEventChannel.receiveBroadcastStream().distinct().map((dynamic event) => (jsonDecode(event ?? '[]') as List<dynamic>));

      return networkStream;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  ///
  /// Get a Stream of the home devices dps updates
  ///
  /// Device model values:
  /// * `"timerId"` : String? The id of the timer
  /// * `"aliasName"` : String? The name of the timer
  /// * `"dpsStatus"` : bool Indicates whether to switch on or off.
  /// * `"loops"` : String? The days that are affected, starting from Sunday. Format: 0100000 - meaning Switches on mondays.
  /// * `"status"` : bool Weather the timer is active.
  /// * `"time"` : int The time it switches.
  ///
  Stream<List<TuyaSmartTimer>>? timersValueStream() {
    try {
      const deviceEventChannel = EventChannel('dk.wejeo.wejeoSmart/timerEvents');
      final networkStream = deviceEventChannel
          .receiveBroadcastStream()
          .distinct()
          .map((dynamic event) => (jsonDecode(event ?? '[]') as List<dynamic>).map((e) => TuyaSmartTimer.fromJson(e)).toList());
      // deviceEventChannel.receiveBroadcastStream().distinct().map((dynamic event) => (jsonDecode(event ?? '[]') as List<dynamic>));

      return networkStream;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getDeviceProperties(String deviceId) async {
    try {
      var result = await _methodChannel.invokeMethod<String?>('getDeviceProperties', deviceId);
      List<dynamic> resultList = jsonDecode(result ?? '[]');
      List<Map<String, dynamic>> mapResult = resultList.map((e) => e as Map<String, dynamic>).toList();
      return mapResult;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  Future<void> removeDevice(
    String deviceId,
    void Function(String message) successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      var result = await _methodChannel.invokeMethod<String?>('removeDevice', deviceId);
      if (result == 'Success') {
        successCallback("Device has been removed");
      } else {
        errorCallback('$result, try again.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error removing device: $e.');
    }
  }

  Future<void> addDeviceTimer(
    String deviceId,
    String time,
    String loops,
    bool dpsStatus,
    void Function(String message) successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'deviceId': deviceId,
        'time': time,
        'loops': loops,
        'dpsStatus': dpsStatus,
      };
      var result = await _methodChannel.invokeMethod<String?>('addDeviceTimer', args);
      if (result == 'Success') {
        successCallback("Timer added");
      } else {
        errorCallback('$result, try again.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error adding timer: $e.');
    }
  }

  // Future<List<Map<String, dynamic>>?> getDeviceTimers(
  //   String deviceId,
  // ) async {
  //   try {
  //     var result = await _methodChannel.invokeMethod<String?>('getDeviceTimers', deviceId);
  //     List<Map<String, dynamic>> resultList = (jsonDecode(result ?? '[]') as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();

  //     print(result);
  //     print(resultList);
  //     return resultList;
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       print('Error: $e');
  //     }
  //     return null;
  //   }
  // }

  Future<void> updateTimerStatus(
    String deviceId,
    List<String> timerIds,
    int updateType,
    void Function(String message) successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'deviceId': deviceId,
        'timerIds': timerIds,
        'updateType': updateType,
      };
      var result = await _methodChannel.invokeMethod<String?>('updateTimerStatus', args);
      if (result == 'Success') {
        successCallback("Timer added");
      } else {
        errorCallback('$result, try again.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('Error adding timer: $e.');
    }
  }
}
