import 'dart:async';

import 'package:flutter/material.dart';

class MyCountDown extends StatefulWidget {
  final int count;
  const MyCountDown({Key? key, required this.count}) : super(key: key);

  @override
  State<MyCountDown> createState() => _MyCountDownState();
}

class _MyCountDownState extends State<MyCountDown> {
  String _counter = '';
  late Timer _timer;

  void startCountDown() {
    int countdown = widget.count - 1;
    _timer = Timer.periodic(const Duration(seconds: 1), (value) {
      if (countdown > 0) {
        setState(() {
          _counter = '$countdown';
          countdown--;
        });
      } else {
        setState(() {
          _counter = '';
          value.cancel();
        });
      }
    });
  }

  @override
  void initState() {
    _counter = '${widget.count}';
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
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(_counter, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 80, width: 80, child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
