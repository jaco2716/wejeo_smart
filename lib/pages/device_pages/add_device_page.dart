import 'package:flutter/material.dart';
import 'package:wejeo_smart/widgets/blinking_power_icon.dart';
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

  int selectedIndex = 0;

  // @override
  // void initState() {
  //   controller.addListener(() {
  //     print('page update, page: ${controller.page}');
  //     setState(() {
  //       selectedIndex = controller.page ?? 0.0;
  //     });
  //   });
  //   super.initState();
  // }

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
      body: Column(
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
                const ConnectWithWifi(),
                Center(
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
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Select reset mode', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const Text('Hold the reset button for 5 secounds', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          BlinkingPowerIcon(durationMili: 290, title: 'Blinking Fast'),
                          BlinkingPowerIcon(durationMili: 1500, title: 'Blinking Slow'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    selectedIndex == 0
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  },
                                  child: const Text('Prev')),
                            ),
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
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
        ],
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
  const ConnectWithWifi({Key? key}) : super(key: key);

  @override
  _ConnectWithWifiState createState() => _ConnectWithWifiState();
}

class _ConnectWithWifiState extends State<ConnectWithWifi> {
  final _formKey = GlobalKey<FormState>();

  final TuyaHandler _tuyaHandler = TuyaHandler();

  final ValidateValues _validateValues = ValidateValues();

  String? password;
  String? ssid;

  String? initialSsid;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: FutureBuilder<String?>(
                future: _tuyaHandler.getWifiName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    initialSsid = snapshot.data;

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
                          setValue: (value) => ssid = value,
                          validate: (value) => _validateValues.validateString(value),
                        ),
                        MyTextFieldWidget(
                          icon: const Icon(Icons.lock),
                          labelText: 'Wifi password',
                          setValue: (value) => password = value,
                          validate: (value) => _validateValues.validateString(value),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState!.validate()) {
                                    // print("widget.groupId, $ssid!, $password!");
                                    showMyDialog(
                                      context,
                                      'Connecting...',
                                      widgetContent: const MyCountDown(count: 100),
                                      infoDialog: false,
                                      onlyAction: true,
                                      barrierDismissible: false,
                                      confirmText: 'Cancel',
                                      myOnPressed: () {
                                        _tuyaHandler.stopParing();
                                        Navigator.pop(context);
                                      },
                                    );
                                    _tuyaHandler.startParing(ssid!, password!, 0, (deviceId) async {
                                      if (mounted) {
                                        Navigator.pop(context);
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
                                },
                                child: const Text('Add Device'))),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
