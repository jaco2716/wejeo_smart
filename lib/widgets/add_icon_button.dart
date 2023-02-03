import 'package:flutter/material.dart';

class AddIconButton extends StatelessWidget {
  final void Function() onPressed;

  const AddIconButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      color: Colors.deepOrange,
      iconSize: 35,
      icon: const Icon(Icons.add_rounded),
    );
  }
}
