import 'package:flutter/material.dart';
import 'package:wejeo_smart/logic/tuya_handler.dart';
import 'package:wejeo_smart/pages/home_pages/home_overview.dart';
import 'package:wejeo_smart/widgets/no_homes_widget.dart';
import 'home_drop_down.dart';
import '../../widgets/menu_popup_button.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final tuyaHandler = TuyaHandler();

  final List<List<String>> homeList = [
    // ['assets/images/homes/house1.png', 'Main Home', 'Devices 3'],
    // ['assets/images/homes/house2.png', 'Summerhouse', 'Devices 1'],
    // ['assets/images/homes/house3.png', 'Rental', 'Devices 0'],
    // ['assets/images/homes/house4.png', 'Another Home', 'Devices 2'],
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
        future: tuyaHandler.getHomeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                appBar: AppBar(actions: [
                  Image.asset('assets/images/wejeologo.png'),
                  const MenuPopupButton(),
                ]),
                body: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                    child: Row(children: [HomeDropDown(homeList: snapshot.data!)]),
                  ),
                ),
                actions: [
                  Image.asset('assets/images/wejeologo.png'),
                  const MenuPopupButton(),
                ],
              ),
              //TODO NOHOMES WIDGET
              body: SafeArea(
                bottom: false,
                child: snapshot.data!.isEmpty ? const NoHomesWidget() : const HomeOverview(),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(actions: [
                  Image.asset('assets/images/wejeologo.png'),
                  const MenuPopupButton(),
                ]),
                body: const Center(child: Text('No data')));
          }
        });
  }
}
