import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingPowerIcon extends StatefulWidget {
  final int durationMili;
  final String title;
  const BlinkingPowerIcon({Key? key, required this.durationMili, required this.title}) : super(key: key);

  @override
  State<BlinkingPowerIcon> createState() => _BlinkingPowerIconState();
}

class _BlinkingPowerIconState extends State<BlinkingPowerIcon> {
  late Timer _timer;
  bool isOn = true;

  void startCountDown() {
    _timer = Timer.periodic(Duration(milliseconds: widget.durationMili), (value) {
      setState(() {
        isOn = !isOn;
      });
    });
  }

  @override
  void initState() {
    startCountDown();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      // decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.power_settings_new_rounded,
              size: 50,
              // color: isOn ? Colors.blueGrey[700] : Colors.lightBlue[100],
              color: isOn ? Colors.black : Colors.lightBlue[100],
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     widget.title,
            //     style: const TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
