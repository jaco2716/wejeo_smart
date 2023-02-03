import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wejeo_smart/logic/tuya_handler.dart';
import 'package:wejeo_smart/logic/validate_values.dart';
import 'package:wejeo_smart/model/tuya_device.dart';
import 'package:wejeo_smart/model/tuya_smart_timer.dart';
import 'package:wejeo_smart/pages/device_pages/add_schedule_page.dart';
import 'package:wejeo_smart/widgets/add_icon_button.dart';
import 'package:wejeo_smart/widgets/my_alert_dialog.dart';
import 'package:wejeo_smart/widgets/my_text_field.dart';

import '../../widgets/schedule_list_tile.dart';

class SingleDevicePage extends StatefulWidget {
  final TuyaDevice device;
  const SingleDevicePage({Key? key, required this.device}) : super(key: key);

  @override
  State<SingleDevicePage> createState() => _SingleDevicePageState();
}

class _SingleDevicePageState extends State<SingleDevicePage> {
  Stream<TuyaDevice>? deviceStream;
  Stream<List<TuyaSmartTimer>>? timerStream;
  // late Future<List<Map<String, dynamic>>?> deviceTimersFuture;
  bool _editSchedules = false;

  @override
  void initState() {
    deviceStream = _tuyaHandler.deviceValueStream(widget.device.devId);
    timerStream = _tuyaHandler.timersValueStream();
    // deviceTimersFuture = _tuyaHandler.getDeviceTimers(widget.device.devId);
    super.initState();
  }

  final _tuyaHandler = TuyaHandler();
  final _validateValues = ValidateValues();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TuyaDevice>(
        stream: deviceStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          // print('#####snapshot:');
          // print(snapshot.data);
          if (!snapshot.hasData) {
            print('no data');
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          var deviceStream = snapshot.data!;
          return Scaffold(
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      final formKey = GlobalKey<FormState>();
                      String? name;

                      showMyDialog(
                        context,
                        // 'Edit Device',
                        '',
                        widgetContent: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 40),
                                  const Text('Edit Device', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: IconButton(
                                      color: Colors.red,
                                      splashRadius: 30,
                                      icon: const Icon(Icons.delete_rounded),
                                      onPressed: () {
                                        showMyDialog(
                                          context,
                                          'Delete Device',
                                          infoDialog: false,
                                          message: 'Are you sure you want to delete this device?',
                                          confirmText: 'Delete',
                                          myOnPressed: () {
                                            showMyLoadingDialog(context);
                                            _tuyaHandler.removeDevice(widget.device.devId, (message) async {
                                              await Future.delayed(const Duration(milliseconds: 500));
                                              if (mounted) {
                                                Navigator.pop(context);
                                              }
                                            }, (message) {
                                              showMyDialog(context, '', message: message);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20, width: 500),
                              MyTextFieldWidget(
                                labelText: 'Name',
                                icon: const Icon(Icons.label_important_rounded),
                                initialValue: snapshot.data!.name,
                                setValue: (value) => name = value,
                                validate: (value) => _validateValues.validateString(value),
                              ),
                            ],
                          ),
                        ),
                        infoDialog: false,
                        myOnPressed: () async {
                          formKey.currentState!.save();
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            showMyLoadingDialog(context);
                            await _tuyaHandler.modifyDeviceName(widget.device.devId, name!, (message) async {
                              await Future.delayed(const Duration(milliseconds: 500));
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            }, (message) {
                              showMyDialog(context, '', message: message);
                            });
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.edit_rounded))
              ],
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Image.asset('assets/images/socket.png'),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(deviceStream.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        Text(deviceStream.isOnline ? 'Online' : 'Offline'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
                  child: Row(
                    children: [
                      const Text('Switch Schedules', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                _editSchedules = !_editSchedules;
                              });
                            },
                            child: Text(_editSchedules ? 'Save' : 'Edit')),
                      ),
                      const Spacer(),
                      AddIconButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddSchedulePage(device: widget.device)));
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<TuyaSmartTimer>?>(
                      stream: timerStream,
                      builder: (context, snapshot) {
                        var timerList = snapshot.data ?? [];
                        print('#####update ');
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (timerList.isEmpty) {
                          return const Center(child: Text('No Schedules', style: TextStyle(fontSize: 26, color: Colors.white60)));
                        } else {
                          return ListView.separated(
                            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white24),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data!.length >= 25) {
                                return Column(
                                  children: [
                                    ScheduleListTile(timer: timerList[index], deviceId: widget.device.devId),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        'You have reached the max number of schedules\nDelete some to add more.\n',
                                        style: TextStyle(color: Colors.white60, fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Row(
                                  children: [
                                    _editSchedules
                                        ? IconButton(
                                            onPressed: () => deleteTimer(timerList[index].timerId),
                                            color: Colors.red,
                                            icon: const Icon(Icons.remove_circle_rounded))
                                        : const SizedBox.shrink(),
                                    Expanded(child: SizedBox(child: ScheduleListTile(timer: snapshot.data![index], deviceId: widget.device.devId))),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      }),
                ),
                Container(
                  color: const Color.fromARGB(255, 21, 32, 30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        clipBehavior: Clip.hardEdge,
                        color: deviceStream.dps['1'] ? Colors.green : Colors.black,
                        child: InkWell(
                          onTapDown: (details) => HapticFeedback.heavyImpact(),
                          onTap: () async {
                            _tuyaHandler.setDeviceValue(widget.device.devId, '1');
                            await Future.delayed(const Duration(milliseconds: 70));
                            HapticFeedback.heavyImpact();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Icon(
                              Icons.power_settings_new_rounded,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
              ],
            ),
          );
        });
  }

  void deleteTimer(String timerId) async {
    showMyLoadingDialog(context);
    await _tuyaHandler.updateTimerStatus(widget.device.devId, [timerId], 2, (message) {}, (message) {});
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}






// Image.asset('assets/images/rooms/livingroomOFF.png'),
                // AnimatedCrossFade(
                //   duration: const Duration(milliseconds: 500),
                //   crossFadeState: deviceStream.dps['1'] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                //   firstChild: Image.asset('assets/images/rooms/livingroomON.png'),
                //   secondChild: Image.asset('assets/images/rooms/livingroomOFF.png'),
                // ),

                // AspectRatio(
                //   aspectRatio: 1,
                //   child: Stack(
                //     children: [
                //       // Align(
                //       //   alignment: Alignment.topCenter,
                //       //   child: SizedBox(
                //       //     height: 150 + MediaQuery.of(context).padding.top,
                //       //     width: double.infinity,
                //       //     child: Container(
                //       //       decoration: const BoxDecoration(
                //       //         gradient: LinearGradient(
                //       //           begin: Alignment.topCenter,
                //       //           end: Alignment.bottomCenter,
                //       //           stops: [0.55, 1],
                //       //           colors: [
                //       //             Color(0x40000000),
                //       //             Color(0x00000000),
                //       //           ],
                //       //         ),
                //       //       ),
                //       //     ),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),