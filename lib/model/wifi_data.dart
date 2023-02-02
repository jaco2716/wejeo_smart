import 'package:flutter/material.dart';

class WifiData {
  String? ssid;
  String? password;

  static final WifiData _wifiData = WifiData._internal();

  factory WifiData.sharedInstance() {
    return _wifiData;
  }

  WifiData._internal();
}
