import 'package:flutter/services.dart';

class ValidateValues {
  //check if string is empty
  String? validateString(String? value) {
    try {
      return value!.isEmpty ? 'Required' : null;
    } catch (e) {
      return 'Required';
    }
  }

  // Check if the number value is valid
  String? validateDouble(String? value) {
    try {
      value = value!.replaceAll(',', '.');
      double.parse(value);
      return null;
    } catch (error) {
      return "Invalid number.";
    }
  }

  // // Check if the number value is valid
  // String? validateInt(String value, {int? aboveValue, int? bellowValue, bool canBeNull = false}) {
  //   try {
  //     if (value == '' && canBeNull) return null;
  //     int intValue = int.parse(value);
  //     if (aboveValue != null) {
  //       if (intValue <= aboveValue) {
  //         return "Must be greater than $aboveValue";
  //       }
  //     }
  //     if (bellowValue != null) {
  //       if (intValue >= bellowValue) {
  //         return "Must be less than $bellowValue";
  //       }
  //     }
  //     return null;
  //   } catch (error) {
  //     return "Invalid number.";
  //   }
  // }

  String? validateRepeatPassword(String? value, String? value2) {
    try {
      return value != value2 ? 'Password does not match.' : null;
    } catch (e) {
      return 'Password does not match.';
    }
  }

  String? validatePassword(String? value) {
    try {
      return value!.length < 6 ? 'Password must be at least 8 characters.' : null;
    } catch (e) {
      return 'Password must be at least 8 characters.';
    }
  }

  String? validateEmail(String? value) {
    // if (value == null) return 'Ugyldig E-mail.';
    try {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      return (!regex.hasMatch(value!)) ? 'Invalid E-mail.' : null;
    } catch (e) {
      return 'Invalid E-mail.';
    }
  }
}

class MyStringFormatter {
  String formatPhoneString(String value, {String separator = '  '}) {
    final chars = value.split('');
    for (var i = 2; i < chars.length; i += 3) {
      chars.insert(i, separator);
    }
    return chars.join();
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales
  static const decimalSeparator = ','; // Change this to ',' for other locales

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    List<String> decimalSeparatedValues = newValue.text.replaceAll(separator, '').split(decimalSeparator);

    String? decimalValue = decimalSeparatedValues.length > 1 ? decimalSeparatedValues[1] : null;

    // Handle "deletion" of separator character
    String newValueText = decimalSeparatedValues[0];

    if (oldValue.text.endsWith(separator) && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValue.text != newValue.text) {
      int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) newString = separator + newString;
        newString = chars[i] + newString;
      }

      String result = decimalValue == null ? newString : '$newString$decimalSeparator$decimalValue';
      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(
          offset: result.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  final MyStringFormatter _stringFormatter = MyStringFormatter();
  static const separator = '  '; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Handle "deletion" of separator character
    String newValueText = newValue.text.replaceAll(separator, '');

    // Only process if the old value and new value are different
    if (oldValue.text != newValue.text) {
      int selectionIndex = newValue.text.length - newValue.selection.extentOffset;
      String newString = _stringFormatter.formatPhoneString(newValueText);
      // final chars = newValueText.split('');

      // for (var i = 2; i < chars.length; i += 3) {
      //   chars.insert(i, separator);
      // }
      // String newString = chars.join();
      // String newString = '';
      // for (int i = 0; i < chars.length; i++) {
      //   if (i % 2 == 0 && i != 0) newString += separator;
      //   newString += chars[i];
      // }

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
