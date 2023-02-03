import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '/logic/auth_app_state.dart';
import '../../../widgets/my_alert_dialog.dart';
import 'create_password_page.dart';

class CheckVerifiCodePage extends StatefulWidget {
  final String email;
  final String countryCode;
  const CheckVerifiCodePage({Key? key, required this.email, required this.countryCode}) : super(key: key);

  @override
  State<CheckVerifiCodePage> createState() => _CheckVerifiCodePageState();
}

class _CheckVerifiCodePageState extends State<CheckVerifiCodePage> {
  final StreamController<ErrorAnimationType> _errorController = StreamController<ErrorAnimationType>();
  final TextEditingController _textEditingController = TextEditingController();
  // String _currentText = '';
  bool _canResend = false;
  bool _codeWrong = false;
  String _counter = '';
  late Timer _timer;

  Future<void> _checkVerificationCode(String email, String countryCode, String verificationCode) async {
    showMyLoadingDialog(context);
    await context.read<AuthAppState>().checkVerificationCode(email, countryCode, verificationCode, () {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreatePasswordPage(
                      verificationCode: verificationCode,
                      email: email,
                    )));
      }
    }, (message) {
      wrongVerificationCode();
    });
  }

  void wrongVerificationCode() {
    setState(() {
      _codeWrong = true;
    });
    _errorController.add(ErrorAnimationType.shake);
  }

  void resendCountdown() {
    int countdown = 30;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (value) {
      if (countdown > 0) {
        setState(() {
          _counter = '($countdown)';
          countdown--;
        });
      } else {
        setState(() {
          _counter = '';
          _canResend = true;
          value.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    resendCountdown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FittedBox(
                        child: Text(
                      'Enter Verification Code',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                const SizedBox(height: 20),
                PinCodeTextField(
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    activeColor: Colors.transparent,
                    disabledColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    selectedColor: Colors.transparent,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    selectedFillColor: Colors.white30,
                    activeFillColor: Colors.white12,
                    inactiveFillColor: Colors.white12,
                    borderWidth: 2,
                    errorBorderColor: Colors.transparent,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  // backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  errorAnimationController: _errorController,
                  controller: _textEditingController,
                  onCompleted: (value) {
                    _checkVerificationCode(widget.email, widget.countryCode, value);
                  },
                  onChanged: (_) {},
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
                SizedBox(
                  height: 20,
                  width: double.infinity,
                  child: Visibility(
                    visible: _codeWrong,
                    child: const Text(
                      'Incorrect verification code. Try again.',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    children: [
                      TextSpan(text: 'A verification code has been sent to your e-mail ${widget.email} '),
                      TextSpan(
                        text: 'Resend $_counter',
                        style: _canResend ? const TextStyle(color: Colors.blue) : null,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (_canResend) {
                              resendCountdown();
                            }
                            // _launchURLWebsite('https://www.ab-one.dk/privacy-policy-ab-one/', context);
                          },
                      ),
                    ],
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
