import 'package:flutter/material.dart';

class MyRequiredDot extends StatelessWidget {
  const MyRequiredDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SizedBox(
        height: 16,
        width: 16,
        child: Icon(
          Icons.circle,
          color: Colors.red[900],
          size: 8,
        ),
      ),
    );
  }
}
