import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app_flutter/Screens/HomePage.dart';

class verifyotp extends StatefulWidget {
  final verificationId;
  const verifyotp({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<verifyotp> createState() => _verifyotpState();
}

class _verifyotpState extends State<verifyotp> with TickerProviderStateMixin {
  //Animation Controller
  late final AnimationController controllerr = AnimationController(
      duration: const Duration(milliseconds: 3000), vsync: this)
    ..repeat();

  TextEditingController otpcontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  void verifyOTP() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: SpinKitSpinningLines(
            color: Colors.black,
            duration: const Duration(seconds: 3),
            size: 60,
            controller: controllerr,
          ));
        });
    String otp = otpcontroller.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => const Homepage()));
        Fluttertoast.showToast(msg: 'Sucessfully Login!');
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code.toString() == 'invalid-verification-code') {
        Fluttertoast.showToast(msg: 'invalid verification code');
        Navigator.of(context).pop();
      }
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Verification',
          style: TextStyle(fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Image.asset(
                  'Assets/Images/phone.png',
                  width: 400,
                  height: 250,
                ),
                TextFormField(
                  controller: otpcontroller,
                  maxLength: 6,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Please Enter OTP';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key),
                    labelText: 'OTP',
                    hintText: 'Enter 6 Digits OTP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 20, bottom: 20),
                            shadowColor: Colors.black,
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            verifyOTP();
                          }
                        },
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
