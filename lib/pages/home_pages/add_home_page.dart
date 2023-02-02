import 'package:flutter/material.dart';

import '../../logic/tuya_handler.dart';
import '../../logic/validate_values.dart';
import '../../widgets/my_alert_dialog.dart';
import '../../widgets/my_text_field.dart';

class AddHomePage extends StatefulWidget {
  const AddHomePage({Key? key}) : super(key: key);

  @override
  State<AddHomePage> createState() => _AddHomePageState();
}

class _AddHomePageState extends State<AddHomePage> {
  final _formKey = GlobalKey<FormState>();

  final TuyaHandler _tuyaHandler = TuyaHandler();

  final ValidateValues _validateValues = ValidateValues();

  String? _title;

  String? _location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Home')),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Give a name to your smarthome', style: TextStyle(color: Colors.white60)),
              MyTextFieldWidget(
                icon: const Icon(Icons.short_text_rounded),
                // autofillHints: const [AutofillHints.name],
                labelText: 'Name',
                // textInputType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                isRequired: false,
                setValue: (value) => _title = value,
                validate: (value) => _validateValues.validateString(value),
              ),
              const Text('Specify a location (optional)', style: TextStyle(color: Colors.white60)),
              MyTextFieldWidget(
                icon: const Icon(Icons.pin_drop),
                // autofillHints: const [AutofillHints.password],
                labelText: 'Location',
                isRequired: false,
                textCapitalization: TextCapitalization.sentences,
                setValue: (value) => _location = value,
                validate: (value) => null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          _tuyaHandler.addHome(_title!, _location!, "Bedroom", 0, 0, (homeId) async {
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }, (message) {
                            showMyDialog(context, 'Error', message: message);
                          });
                        }
                      },
                      child: const Text('Add Home'))),
            ],
          ),
        ),
      )),
    );
  }
}
