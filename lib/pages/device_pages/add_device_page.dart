import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wejeo_smart/model/wifi_data.dart';
import '../../logic/tuya_handler.dart';
import '../../logic/validate_values.dart';
import '../../widgets/my_alert_dialog.dart';
import '../../widgets/my_count_down.dart';
import '../../widgets/my_text_field.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final controller = PageController();
  final TuyaHandler _tuyaHandler = TuyaHandler();
  final WifiData _wifiData = WifiData.sharedInstance();
  final _formKey = GlobalKey<FormState>();

  int selectedIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          // title: const Text('Add Device'),
          ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (int page) {
                  setState(() {
                    selectedIndex = page;
                  });
                },
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ConnectWithWifi(controller: controller, formKey: _formKey),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Reset the device', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          const Text('Hold the reset button for 5 secounds', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          const SizedBox(height: 20),
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/smartplug_reset.png',
                              width: 250,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Connecting', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      MyCountDown(count: 100),
                    ],
                  )),
                  // Center(
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       const Text('Select reset mode', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  //       const Text('Hold the reset button for 5 secounds', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  //       const SizedBox(height: 40),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: const [
                  //           BlinkingPowerIcon(durationMili: 290, title: 'Blinking Fast'),
                  //           BlinkingPowerIcon(durationMili: 1500, title: 'Blinking Slow'),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                    // TextButton(onPressed: () {}, child: Text('Back')),
                    const SizedBox(width: 70),
                    Row(
                      children: [
                        selectedIndex == 0
                            ? const SizedBox.shrink()
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                      // style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                                      onPressed: () {
                                        if (selectedIndex == 2) {
                                          _tuyaHandler.stopParing();
                                        }
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                      },
                                      child: Text(selectedIndex == 2 ? 'Cancel' : 'Back')),
                                ),
                              ),
                        selectedIndex == 2
                            ? const SizedBox.shrink()
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (selectedIndex == 0) {
                                          _formKey.currentState!.save();
                                          if (!_formKey.currentState!.validate()) {
                                            return;
                                          }

                                          SharedPreferences.getInstance().then((prefs) {
                                            Map<String, dynamic> ssidPass = {
                                              _wifiData.ssid!: _wifiData.password,
                                            };
                                            prefs.setString('ssidPass', jsonEncode(ssidPass));
                                          });
                                        } else if (selectedIndex == 1) {
                                          _tuyaHandler.startParing(_wifiData.ssid!, _wifiData.password!, (deviceId) async {
                                            if (mounted) {
                                              showMyDialog(context, 'Success', message: "Successfully connected to device").then((value) {
                                                if (mounted) {
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }
                                              });
                                            }
                                          }, (message) {
                                            if (mounted) {
                                              Navigator.pop(context);
                                              showMyDialog(context, 'Error', message: message);
                                            }
                                          });
                                        }
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                      },
                                      child: const Text('Next')),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : const BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Colors.deepOrange : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}

class ConnectWithWifi extends StatefulWidget {
  final PageController controller;
  final GlobalKey<FormState> formKey;
  const ConnectWithWifi({Key? key, required this.controller, required this.formKey}) : super(key: key);

  @override
  State<ConnectWithWifi> createState() => _ConnectWithWifiState();
}

class _ConnectWithWifiState extends State<ConnectWithWifi> {
  // final _formKey = GlobalKey<FormState>();
  final TuyaHandler _tuyaHandler = TuyaHandler();
  final ValidateValues _validateValues = ValidateValues();
  final _wifiData = WifiData.sharedInstance();
  String? password;
  String? ssid;
  String? initialSsid;
  String? initialPass;
  late Future<List<String?>?> getWifiNameFuture;

  @override
  void initState() {
    getWifiNameFuture = _tuyaHandler.getWifiName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: FutureBuilder<List<String?>?>(
              future: getWifiNameFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  initialSsid = snapshot.data?[0];
                  initialPass = snapshot.data?[1];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Connect to Device', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                      ),
                      const Text('Make sure your device is in paring mode.', style: TextStyle(color: Colors.white60)),
                      const SizedBox(height: 10),
                      MyTextFieldWidget(
                        labelText: 'Wifi name',
                        icon: const Icon(Icons.wifi),
                        initialValue: initialSsid,
                        setValue: (value) => _wifiData.ssid = value,
                        validate: (value) => _validateValues.validateString(value),
                      ),
                      MyTextFieldWidget(
                        labelText: 'Wifi password',
                        icon: const Icon(Icons.lock),
                        initialValue: initialPass,
                        setValue: (value) => _wifiData.password = value,
                        validate: (value) => _validateValues.validateString(value),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
