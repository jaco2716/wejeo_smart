import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:wejeo_smart/logic/tuya_handler.dart';
import 'package:wejeo_smart/model/tuya_home.dart';

class TuyaHomeProvider extends ChangeNotifier {
  final _tuyaHandler = TuyaHandler();
  List<TuyaHome>? homeList;
  ConnectionState _connectionState = ConnectionState.waiting;
  ConnectionState get connectionState => _connectionState;

  TuyaHomeProvider() {
    getHomeFuture();
  }

  void getHomeFuture() async {
    _connectionState = ConnectionState.waiting;
    homeList = await _tuyaHandler.getHomeList();
    if (homeList != null) {
      if (homeList!.isEmpty) {
        await _tuyaHandler.addHome('My Home new', '', '', 0, 0, (homeId) {}, (message) {});
        await Future.delayed(const Duration(milliseconds: 200));
        homeList = await _tuyaHandler.getHomeList();
      }
    } else {
      if (kDebugMode) {
        print('Trying again to getHomeList');
      }
      homeList = await _tuyaHandler.getHomeList();
    }
    _connectionState = ConnectionState.done;
    notifyListeners();
  }
}
