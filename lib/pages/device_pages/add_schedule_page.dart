import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wejeo_smart/logic/tuya_handler.dart';
import 'package:wejeo_smart/model/tuya_device.dart';
import 'package:wejeo_smart/widgets/my_alert_dialog.dart';

class AddSchedulePage extends StatefulWidget {
  final TuyaDevice device;
  const AddSchedulePage({Key? key, required this.device}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  Duration _initialTimer = const Duration();
  bool _switchValue = true;
  final List<String> _weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final List<bool> _weekSelected = [false, false, false, false, false, false, false];

  @override
  void initState() {
    var timeNow = DateTime.now();
    _initialTimer = Duration(hours: timeNow.hour, minutes: timeNow.minute);
    _weekSelected[(timeNow.weekday) % 7] = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Schedule')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              child: Transform.scale(
                scale: 0.9,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  minuteInterval: 1,
                  initialTimerDuration: _initialTimer,
                  onTimerDurationChanged: (Duration changeTimer) {
                    setState(() {
                      _initialTimer = changeTimer;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Switch on / off?'),
                  Text(
                    _switchValue ? 'ON' : 'OFF',
                    style: TextStyle(fontSize: 10, color: _switchValue ? Colors.green : Colors.orange),
                  ),
                ],
              ),
              visualDensity: VisualDensity.compact,
              // subtitle: Text(
              //   _switchValue ? 'ON' : 'OFF',
              //   style: const TextStyle(fontSize: 10),
              // ),
              trailing: Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  }),
            ),
            Material(
              color: const Color.fromARGB(255, 21, 32, 30),
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.hardEdge,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(height: 1);
                },
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _weekDays.length,
                itemBuilder: (context, index) {
                  int newIndex = (index + 1) % 7;
                  return SizedBox(
                    // height: 40,
                    child: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.transparent, brightness: Brightness.dark),
                      child: CheckboxListTile(
                        visualDensity: VisualDensity.compact,
                        activeColor: Colors.transparent,
                        checkColor: Colors.orange,
                        dense: true,
                        value: _weekSelected[newIndex],
                        onChanged: (value) {
                          setState(() {
                            _weekSelected[newIndex] = value!;
                          });
                        },
                        title: Text(_weekDays[newIndex], style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Create Schedule'),
                onPressed: () async {
                  // String time = '${_initialTimer.inHours}:${_initialTimer.inMinutes}';
                  String time = '${_initialTimer.inHours.toString().padLeft(2, '0')}:${(_initialTimer.inMinutes % 60).toString().padLeft(2, '0')}';
                  String loops = '';
                  for (var day in _weekSelected) {
                    if (day) {
                      loops += '1';
                    } else {
                      loops += '0';
                    }
                  }
                  if (loops == '0000000') {
                    showMyDialog(context, '', message: 'Please select at least 1 day');
                  } else {
                    TuyaHandler tuyaHandler = TuyaHandler();
                    await tuyaHandler.addDeviceTimer(widget.device.devId, time, loops, _switchValue, (message) {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    }, (message) {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                      showMyDialog(context, '', message: message);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
