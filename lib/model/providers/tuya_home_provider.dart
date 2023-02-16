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
    getHomeFuture(0);
  }

  void getHomeFuture(int attempt) async {
    _connectionState = ConnectionState.waiting;
    homeList = await _tuyaHandler.getHomeList();
    if (kDebugMode) {
      print('Trying to getHomeList attempt: ${attempt + 1}');
    }
    if (attempt > 3) {
      _connectionState = ConnectionState.done;
      notifyListeners();
    } else {
      if (homeList == null) {
        await Future.delayed(const Duration(milliseconds: 400));
        getHomeFuture(attempt++);
      } else if (homeList!.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 400));
        await _tuyaHandler.addHome('My Home new', '', '', 0, 0, (homeId) {}, (message) {});
        await Future.delayed(const Duration(milliseconds: 400));
        getHomeFuture(attempt++);
      } else {
        _connectionState = ConnectionState.done;
        notifyListeners();
      }
    }
  }
}
