import 'package:flutter/material.dart';

class MyCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final double size;

  const MyCheckbox({Key? key, required this.value, required this.onChanged, this.size = 1.7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: size,
      child: StatefulBuilder(builder: (BuildContext context, setState) {
        return Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange,
        );
      }),
    );
  }
}
