import 'package:flutter/material.dart';

import '../logic/tuya_handler.dart';

class ScheduleListTile extends StatefulWidget {
  final String deviceId;
  final Map<String, dynamic> timer;
  const ScheduleListTile({
    Key? key,
    required this.timer,
    required this.deviceId,
  }) : super(key: key);

  @override
  State<ScheduleListTile> createState() => _ScheduleListTileState();
}

class _ScheduleListTileState extends State<ScheduleListTile> {
  final List<String> weekDays = [
    'Sun, ',
    'Mon, ',
    'Tue, ',
    'Wed, ',
    'Thu, ',
    'Fri, ',
    'Sat, ',
  ];

  @override
  Widget build(BuildContext context) {
    String loops = widget.timer['loops'];
    String weekDayString = '';
    if (loops == '1111111') {
      weekDayString = 'Every Day';
    } else {
      for (var i = 0; i < loops.length; i++) {
        if (loops[i] == '1') {
          weekDayString += weekDays[i];
        }
      }
      weekDayString = weekDayString.substring(0, weekDayString.length - 2);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () {},
        // leading: Image.asset('assets/images/socket.png'),
        leading: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            const Icon(
              Icons.access_time,
              size: 50,
            ),
            SizedBox(
                height: 22,
                width: 22,
                child: CircleAvatar(
                    backgroundColor: widget.timer['dpsStatus'] ? Colors.green : Colors.deepOrange,
                    foregroundColor: Colors.white,
                    child: const Icon(
                      Icons.power_settings_new_rounded,
                      size: 20,
                    )))
          ],
        ),
        // title: Text('Switch on: 19:30'),
        title: Text('Switch ${widget.timer['dpsStatus'] ? 'on' : 'off'}: ${widget.timer['time']}'), //'Switch on: 19:30'),
        subtitle: Text(
          weekDayString,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Switch(
          onChanged: (value) async {
            TuyaHandler tuyaHandler = TuyaHandler();
            await tuyaHandler.updateTimerStatus(widget.deviceId, [widget.timer['timerId']], widget.timer['status'] ? 0 : 1, (message) {
              print('working');
            }, (message) {
              print('not working');
            });
            setState(() {});
          },
          value: widget.timer['status'],
        ),
      ),
    );
  }
}
