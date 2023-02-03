import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AppLoginState {
  loggedIn,
  loggedOut,
  registerUser,
  resetPassword,
}

enum VerificationType {
  nil,
  registerUser,
  loginWithEmail,
  resetPassword,
}

class AuthAppState extends ChangeNotifier {
  static const _methodChannel = MethodChannel('dk.wejeo.wejeoSmart/tuya');

  AppLoginState _loginState = AppLoginState.loggedOut;
  AppLoginState get loginState => _loginState;
  set loginState(value) {
    if (_loginState != AppLoginState.loggedIn) {
      _loginState = value;
    }
  }

  AuthAppState() {
    checkLogin();
  }

  Future<void> checkLogin() async {
    try {
      final bool result = await _methodChannel.invokeMethod('checkIsLoggedIn');
      if (result) {
        _loginState = AppLoginState.loggedIn;
      } else {
        _loginState = AppLoginState.loggedOut;
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      _loginState = AppLoginState.loggedOut;
    }
    notifyListeners();
  }

  Future<void> loginWithEmail(
    String email,
    String password,
    String countryCode,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'email': email,
        'password': password,
        'countryCode': countryCode,
      };
      final String? result = await _methodChannel.invokeMethod('loginWithEmail', args);
      if (kDebugMode) {
        print('Result: $result');
      }
      if (result != null) {
        if (result == 'Success') {
          await checkLogin();
          successCallback();
        } else {
          errorCallback(result);
        }
      } else {
        errorCallback('Something went wrong');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e \n Code: ${e.code} \n details: ${e.details}');
      }
      errorCallback('${e.message}');
    }
  }

  Future<void> logOutUser(
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      final String? result = await _methodChannel.invokeMethod('logOutUser');
      if (kDebugMode) {
        print('Result: $result');
      }
      if (result != null) {
        if (result == 'Success') {
          await checkLogin();
          successCallback();
        } else {
          errorCallback(result);
        }
      } else {
        errorCallback('Something went wrong');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('${e.message}');
    }
  }

  Future<void> sendVerificationCode(
    String email,
    String countryCode,
    VerificationType type,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'email': email,
        'countryCode': countryCode,
        'type': type.index,
      };
      final String result = await _methodChannel.invokeMethod('sendVerificationCode', args);
      if (kDebugMode) {
        print('Result: $result');
      }
      if (result == 'Success') {
        successCallback();
      } else {
        errorCallback(result);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('${e.message}');
    }
  }

  Future<void> checkVerificationCode(
    String email,
    String countryCode,
    String verificationCode,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'email': email,
        'countryCode': countryCode,
        'verificationCode': verificationCode,
      };
      final String result = await _methodChannel.invokeMethod('checkVerificationCode', args);
      if (kDebugMode) {
        print('Result: $result');
      }
      if (result == 'Success') {
        successCallback();
      } else {
        errorCallback(result);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('${e.message}');
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String countryCode,
    String verificationCode,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'email': email,
        'countryCode': countryCode,
        'password': password,
        'verificationCode': verificationCode,
      };
      final String result = await _methodChannel.invokeMethod('registerUser', args);
      Future.delayed(const Duration(milliseconds: 100));
      await checkLogin();
      if (result == 'Success') {
        successCallback();
      } else {
        errorCallback(result);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('${e.message}');
    }
  }

  Future<void> resetPasswordByEmail(
    String email,
    String password,
    String countryCode,
    String verificationCode,
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      Map<String, dynamic> args = {
        'email': email,
        'countryCode': countryCode,
        'password': password,
        'verificationCode': verificationCode,
      };
      final String result = await _methodChannel.invokeMethod('resetPasswordByEmail', args);
      if (result == 'Success') {
        await checkLogin();
        successCallback();
      } else {
        errorCallback(result);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('${e.message}');
    }
  }

  Future<void> cancelAccount(
    void Function() successCallback,
    void Function(String message) errorCallback,
  ) async {
    try {
      final String? result = await _methodChannel.invokeMethod('cancelAccount');
      await checkLogin();
      if (kDebugMode) {
        print('Result: $result');
      }
      if (result != null) {
        if (result == 'Success') {
          await checkLogin();
          successCallback();
        } else {
          errorCallback(result);
        }
      } else {
        errorCallback('Something went wrong');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      errorCallback('${e.message}');
    }
  }
}
