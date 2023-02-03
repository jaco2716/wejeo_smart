import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../logic/validate_values.dart';
import '../../../logic/auth_app_state.dart';
import '../../../model/country_code.dart';
import '../../../widgets/my_alert_dialog.dart';
import '../../../widgets/my_checkbox.dart';
import '../../../widgets/my_required_dot.dart';
import '../../../widgets/my_text_field.dart';
import 'check_verifi_code_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.asset('assets/images/wejeologo.png'),
          )
        ],
      ),
      // backgroundColor: Colors.grey[850],
      // backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: const [
                // const SizedBox(height: 100),
                // Image.asset('assets/images/houseTrans2.png'),
                Text(
                  'Create account for your smarthome',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 450,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 00.0, horizontal: 20),
                    child: RegisterForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final ValidateValues _validateValues = ValidateValues();

  final _formKey = GlobalKey<FormState>();
  String? _email;
  // String? _password;
  // String? _repeatPassword;
  bool _hasAcceptedTerms = false;
  bool _showTermsNotAccepted = false;
  final _countryCode = CountryCode(country: "Denmark", code: 45);

  Future<void> _sendVerificationCode(String email, String countryCode) async {
    context.read<AuthAppState>().loginState = AppLoginState.registerUser;
    showMyLoadingDialog(context);
    await context.read<AuthAppState>().sendVerificationCode(
      email,
      countryCode,
      VerificationType.registerUser,
      () {
        if (mounted) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckVerifiCodePage(email: email, countryCode: countryCode)));
        }
      },
      (message) {
        if (mounted) {
          Navigator.pop(context);
          showMyDialog(context, '', message: message);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.email),
            autofillHints: const [AutofillHints.email],
            labelText: 'E-mail',
            textInputType: TextInputType.emailAddress,
            setValue: (value) => _email = value,
            validate: (value) => _validateValues.validateEmail(value),
          ),
          // MyTextFieldWidget(
          //   icon: const Icon(Icons.lock),
          //   labelText: 'Password',
          //   obscureText: true,
          //   textCapitalization: TextCapitalization.none,
          //   setValue: (value) => _password = value,
          //   validate: (value) => _validateValues.validatePassword(value),
          // ),
          // MyTextFieldWidget(
          //   icon: const Icon(Icons.lock),
          //   labelText: 'Gentag Password',
          //   obscureText: true,
          //   textCapitalization: TextCapitalization.none,
          //   setValue: (value) => _repeatPassword = value,
          //   validate: (value) => validateRepeatPassword(),
          // ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0, right: 14.0),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 38,
                      child: MyCheckbox(
                          value: _hasAcceptedTerms,
                          onChanged: (value) {
                            setState(() {
                              _hasAcceptedTerms = value ?? false;
                              if (_hasAcceptedTerms) _showTermsNotAccepted = false;
                            });
                          }),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Colors.orange),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // _launchURLWebsite('https://www.ab-one.dk/privacy-policy-ab-one/', context);
                                },
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Terms & Conditions.',
                              style: const TextStyle(color: Colors.orange),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // _launchURLWebsite('https://www.ab-one.dk/terms-and-conditions/', context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const MyRequiredDot(),
            ],
          ),
          Visibility(
              visible: _showTermsNotAccepted,
              child: const Text(
                'Accept the Privacy Policy and Terms & Conditions.',
                style: TextStyle(color: Colors.red, fontSize: 10),
              )),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Create Account'),
              onPressed: () {
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  if (!_hasAcceptedTerms) {
                    setState(() {
                      _showTermsNotAccepted = true;
                    });
                  } else {
                    // showMyLoadingDialog(context);
                    _sendVerificationCode(_email!, _countryCode.code.toString());
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
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
