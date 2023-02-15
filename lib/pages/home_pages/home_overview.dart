import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wejeo_smart/logic/tuya_handler.dart';
import 'package:wejeo_smart/model/tuya_device.dart';
import 'package:wejeo_smart/pages/device_pages/add_device_page.dart';
import 'package:wejeo_smart/widgets/add_icon_button.dart';
import '../device_pages/single_device_page.dart';

class HomeOverview extends StatefulWidget {
  const HomeOverview({Key? key}) : super(key: key);

  @override
  State<HomeOverview> createState() => _HomeOverviewState();
}

class _HomeOverviewState extends State<HomeOverview> {
  final List<List<String>> roomList = [
    ['assets/images/rooms/livingroom1.png', 'Living Room'],
    ['assets/images/rooms/bedroom1.png', 'Bedroom'],
    ['assets/images/rooms/bathroom1.png', 'Bathroom'],
    ['assets/images/rooms/kitchen1.png', 'Kitchen'],
  ];
  Stream<List<TuyaDevice>>? devicesStream;
  final _tuyaHandler = TuyaHandler();

  @override
  void initState() {
    devicesStream = _tuyaHandler.homeDevicesValueStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(alignment: Alignment.centerLeft, child: Text('Devices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
              AddIconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDevicePage(), fullscreenDialog: true));
              }),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<TuyaDevice>>(
              stream: devicesStream,
              builder: (context, snapshot) {
                print(" #Home device Update ");
                var deviceList = snapshot.data ?? [];
                print(deviceList.toString());
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (deviceList.isEmpty) {
                  return const Center(
                    child: Text('No Devices', style: TextStyle(fontSize: 26, color: Colors.white60)),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white24),
                    itemCount: deviceList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: SmartDeviceListTile(
                          device: deviceList[index],
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ],
    );
  }
}

class SmartDeviceListTile extends StatelessWidget {
  final TuyaDevice device;

  SmartDeviceListTile({
    Key? key,
    required this.device,
  }) : super(key: key);
  final TuyaHandler _tuyaHandler = TuyaHandler();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleDevicePage(device: device), fullscreenDialog: false));
      },
      leading: Image.asset(
        // image: const AssetImage('assets/images/socket.png'),
        'assets/images/socket.png',
        width: 55,
      ),
      title: Text(device.name),
      subtitle: device.isOnline
          ? const Text('Online', style: TextStyle(color: Colors.green))
          : const Text('Offline', style: TextStyle(color: Colors.orange)),
      trailing: device.isOnline
          ? Material(
              clipBehavior: Clip.hardEdge,
              color: device.dps["1"] ? Colors.green : Colors.black,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTapDown: (details) => HapticFeedback.heavyImpact(),
                onTap: () async {
                  _tuyaHandler.setDeviceValue(device.devId, '1');
                  await Future.delayed(const Duration(milliseconds: 70));
                  HapticFeedback.heavyImpact();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.power_settings_new_rounded),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
