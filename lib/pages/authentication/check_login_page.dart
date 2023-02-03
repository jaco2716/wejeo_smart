import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wejeo_smart/pages/home_pages/my_home_page.dart';
import '../../logic/auth_app_state.dart';
import 'login_page.dart';

class CheckLoginPage extends StatefulWidget {
  const CheckLoginPage({Key? key}) : super(key: key);

  @override
  State<CheckLoginPage> createState() => _CheckLoginPageState();
}

class _CheckLoginPageState extends State<CheckLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthAppState>(
      builder: (context, appState, _) {
        if (appState.loginState == AppLoginState.loggedIn) {
          return const MyHomePage();
        } else {
          return const LoginPage();
        }
      },
    );
    // return FutureBuilder<bool>(
    //   future: _checkLogin(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       if (snapshot.data!) {
    //         return const HomePage();
    //       } else {
    //         return const LoginPage();
    //       }
    //     } else {
    //       return const Scaffold(body: Center(child: CircularProgressIndicator()));
    //     }
    //   },
    // );
  }
}
