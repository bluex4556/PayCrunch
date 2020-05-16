import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pay_crunch/auth_service.dart';
import 'package:pay_crunch/widget/app_bar_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(title: "Login",),
        body: Builder(builder: (BuildContext context) {
          return Container(
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (!_codeSent)
                    ? TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Phone number'),
                        autofocus: true,
                        onFieldSubmitted: (_) => _verifyPhoneNumber(),
                      )
                    : TextFormField(
                        maxLength: 6,
                        autofocus: true,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        controller: _smsController,
                        decoration: const InputDecoration(
                            labelText: 'Verification code'),
                  onFieldSubmitted: (_) => _signInWithPhoneNumber(context),

                      ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () async {
                      (!_codeSent)
                          ? _verifyPhoneNumber()
                          : _signInWithPhoneNumber(context);
                    },
                    child: (!_codeSent)
                        ? const Text('Verify phone number')
                        : const Text("Enter OTP"),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          );
        }));
  }

  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      AuthService().signIn(phoneAuthCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber(BuildContext context) async {
    FirebaseUser user;
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    try {
      user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
    } catch (Exception) {
      user = null;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Incorrect Verification code"),
      ));
      print("error");
    }
  }
}
