import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_required_dot.dart';

class MyTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Widget? icon;
  final Color? color;
  final bool obscureText;
  final void Function(String?) setValue;
  final String? Function(String?) validate;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final double horizontalPaddig;
  final TextCapitalization textCapitalization;
  final String? initialValue;
  final bool readOnly;
  final bool isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;

  const MyTextFieldWidget({
    Key? key,
    this.hintText,
    this.labelText,
    this.icon,
    this.color,
    this.obscureText = false,
    required this.setValue,
    required this.validate,
    this.controller,
    this.textInputType = TextInputType.text,
    this.horizontalPaddig = 0,
    this.textCapitalization = TextCapitalization.words,
    this.initialValue,
    this.readOnly = false,
    this.isRequired = true,
    this.inputFormatters,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: horizontalPaddig, right: horizontalPaddig, top: 5, bottom: 5),
      child: Stack(
        children: [
          TextFormField(
            maxLines: maxLines,
            readOnly: readOnly,
            initialValue: initialValue,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              label: labelText != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xFF253535),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                          child: Text(labelText!)),
                    )
                  : null,
              filled: true,
              fillColor: color ?? const Color(0xFF253535),
              alignLabelWithHint: true,
              errorStyle: const TextStyle(fontSize: 10, height: 0.2),
              prefixIcon: icon,
              suffixIconConstraints: const BoxConstraints(maxWidth: 12),
              isDense: true,
              hintText: hintText,
            ),
            autofillHints: autofillHints,
            textCapitalization: textCapitalization,
            autocorrect: false,
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            validator: (value) => validate(value),
            onSaved: (value) => setValue(value),
          ),
          isRequired ? const MyRequiredDot() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
