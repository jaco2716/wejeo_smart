import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wejeo_smart/model/providers/tuya_home_provider.dart';
import 'package:wejeo_smart/pages/home_pages/home_overview.dart';
import '../../widgets/menu_popup_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  // final List<List<String>> homeList = [
  // ['assets/images/homes/house1.png', 'Main Home', 'Devices 3'],
  // ['assets/images/homes/house2.png', 'Summerhouse', 'Devices 1'],
  // ['assets/images/homes/house3.png', 'Rental', 'Devices 0'],
  // ['assets/images/homes/house4.png', 'Another Home', 'Devices 2'],
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TuyaHomeProvider>(builder: (context, value, _) {
      if (value.connectionState == ConnectionState.waiting) {
        return Scaffold(appBar: appBarWithLogout(), body: const Center(child: CircularProgressIndicator()));
      } else if (value.homeList != null) {
        return Scaffold(
          appBar: appBarWithLogout(),
          body: const SafeArea(
            bottom: false,
            child: HomeOverview(),
          ),
        );
      } else {
        return Scaffold(
            appBar: appBarWithLogout(),
            body: const Center(child: Text('No connection.\nCheck your internet or restart the app.', textAlign: TextAlign.center)));
      }
    });
  }

  AppBar appBarWithLogout() {
    return AppBar(
      toolbarHeight: 70,
      title: SizedBox(width: 150, child: Image.asset('assets/images/wejeologo.png')),
      actions: const [
        MenuPopupButton(),
      ],
    );
  }
}
