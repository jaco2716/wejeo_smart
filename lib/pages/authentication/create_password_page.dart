import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../logic/validate_values.dart';
import '../../../logic/auth_app_state.dart';
import '../../../model/country_code.dart';
import '../../../widgets/my_alert_dialog.dart';
import '../../widgets/my_text_field.dart';

class CreatePasswordPage extends StatelessWidget {
  final String verificationCode;
  final String email;
  const CreatePasswordPage({Key? key, required this.verificationCode, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(width: 140, padding: const EdgeInsets.all(12), child: const Icon(Icons.signpost_rounded)),
              SizedBox(
                width: 450,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 00.0, horizontal: 20),
                  child: CreatePasswordForm(email: email, verificationCode: verificationCode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePasswordForm extends StatefulWidget {
  final String verificationCode;
  final String email;
  const CreatePasswordForm({Key? key, required this.verificationCode, required this.email}) : super(key: key);

  @override
  State<CreatePasswordForm> createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  final ValidateValues _validateValues = ValidateValues();
  var buttonTitle = '';

  final _formKey = GlobalKey<FormState>();
  // String? _email;
  String? _password;
  String? _repeatPassword;
  // String? _verificationCode;
  // String? _password;
  // String? _repeatPassword;
  // bool _hasAcceptedTerms = false;
  // bool _showTermsNotAccepted = false;
  final _countryCode = CountryCode(country: "Denmark", code: 45);

  Future<void> _registerUser(String email, String password, String countryCode, String verificationCode) async {
    showMyLoadingDialog(context);
    await context.read<AuthAppState>().registerUser(email, password, countryCode, verificationCode, () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }, (message) {
      if (mounted) {
        Navigator.pop(context);
        showMyDialog(context, 'Error', message: message);
      }
    });
  }

  Future<void> _resetPassword(String email, String password, String countryCode, String verificationCode) async {
    showMyLoadingDialog(context);
    await context.read<AuthAppState>().resetPasswordByEmail(email, password, countryCode, verificationCode, () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }, (message) {
      if (mounted) {
        Navigator.pop(context);
        showMyDialog(context, 'Error', message: message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthAppState>(
      builder: (context, appState, _) {
        if (appState.loginState == AppLoginState.resetPassword) {
          buttonTitle = 'Reset Password';
        } else {
          buttonTitle = 'Create Account';
        }
        return Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextFieldWidget(
                initialValue: _countryCode.country,
                icon: const Icon(Icons.language),
                autofillHints: const [AutofillHints.email],
                labelText: 'Country',
                readOnly: true,
                isRequired: false,
                // onTap: () async {
                //   CountryCode? code = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const AlphabetListSelector(),
                //         fullscreenDialog: true,
                //       ));
                //   if (code != null) {
                //     _countryCode = code;
                //   }
                //   setState(() {});
                // },
                setValue: (_) {},
                validate: (value) => null,
              ),
              MyTextFieldWidget(
                icon: const Icon(Icons.lock),
                labelText: 'Password',
                obscureText: true,
                textCapitalization: TextCapitalization.none,
                setValue: (value) => _password = value,
                validate: (value) => _validateValues.validatePassword(value),
              ),
              MyTextFieldWidget(
                icon: const Icon(Icons.lock),
                labelText: 'Repeat Password',
                obscureText: true,
                textCapitalization: TextCapitalization.none,
                setValue: (value) => _repeatPassword = value,
                validate: (value) => _validateValues.validateRepeatPassword(_password, _repeatPassword),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(buttonTitle),
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      // showMyLoadingDialog(context);
                      if (appState.loginState == AppLoginState.resetPassword) {
                        _resetPassword(widget.email, _password!, _countryCode.code.toString(), widget.verificationCode);
                      } else {
                        _registerUser(widget.email, _password!, _countryCode.code.toString(), widget.verificationCode);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }

  // String? validateRepeatPassword() {
  //   try {
  //     return _password != _repeatPassword ? 'Password stemmer ikke overens.' : null;
  //   } catch (e) {
  //     return 'Password stemmer ikke overens.';
  //   }
  // }

  // _launchURLWebsite(String url, BuildContext context) async {
  //   MailHandler mailHandler = MailHandler();
  //   mailHandler.openWebsite(url, (message) => showMyDialog(context, 'Fejl', message));
  // }
}
