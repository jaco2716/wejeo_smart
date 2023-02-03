import 'package:flutter/material.dart';
import 'package:wejeo_smart/model/tuya_home.dart';
import 'package:wejeo_smart/pages/home_pages/add_home_page.dart';
import 'package:wejeo_smart/res/constants.dart';
import 'package:wejeo_smart/widgets/add_icon_button.dart';

class HomeDropDown extends StatelessWidget {
  final List<TuyaHome> homeList;
  const HomeDropDown({
    Key? key,
    required this.homeList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // homeList = [
    //   {'name': 'Main Home', 'homeId': ''},
    //   {'name': 'sec Home', 'homeId': ''},
    //   {'name': 'thisssa', 'homeId': ''},
    //   {'name': 'thisssa ', 'homeId': ''},
    // ];
    return Material(
      borderRadius: BorderRadius.circular(40),
      color: Colors.transparent,
      // decoration: BoxDecoration(
      // ),
      clipBehavior: Clip.hardEdge,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        offset: const Offset(-20, 60),
        onSelected: (value) {
          if (value == 'Add Home') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHomePage()));
          }
        },
        itemBuilder: (BuildContext context) => homeList.asMap().entries.map<PopupMenuEntry<String>>((e) {
          if (e.key + 1 == homeList.length) {
            return PopupMenuItem<String>(
              height: 0,
              padding: EdgeInsets.zero,
              value: 'Add Home',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: HomeListTile(home: TuyaHome(name: 'Add Home', homeId: 0)),
              ),
            );
          }
          var nextHome = homeList[e.key + 1];
          return PopupMenuItem<String>(
              height: 0,
              padding: EdgeInsets.zero,
              value: nextHome.name,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white24))),
                child: HomeListTile(home: nextHome),
              ));
        }).toList(),
        child: homeList.isEmpty
            ? InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHomePage()));
                },
                child: HomeListTile(home: TuyaHome(name: 'Add Home', homeId: 0)))
            : HomeListTile(home: homeList[0], showTick: true),
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  const HomeListTile({
    Key? key,
    required this.home,
    this.showTick = false,
  }) : super(key: key);

  final TuyaHome home;
  final bool showTick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: 260,
      // constraints: const BoxConstraints(maxWidth: 250),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 50,
          //   width: 50,
          //   child: Material(
          //     clipBehavior: Clip.hardEdge,
          //     borderRadius: BorderRadius.circular(60),
          //     child: home['homeId'] == null ? const CircleAvatar(child: Icon(Icons.add_rounded)) : Image.asset(homeImagePaths[0]),
          //   ),
          // ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(home.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 6),
          showTick ? const Icon(Icons.arrow_drop_down) : const SizedBox.shrink(),
          home.homeId == 0 ? const Icon(Icons.add_rounded, color: Colors.deepOrange, size: 30) : const SizedBox.shrink(),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
