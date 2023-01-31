import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app_flutter/Screens/Otp_Screen.dart';

class SigninPhone extends StatefulWidget {
  const SigninPhone({Key? key}) : super(key: key);

  @override
  State<SigninPhone> createState() => _SigninPhoneState();
}

class _SigninPhoneState extends State<SigninPhone>
    with TickerProviderStateMixin {
  //Animation Controller
  late final AnimationController controllerr = AnimationController(
      duration: const Duration(milliseconds: 3000), vsync: this)
    ..repeat();

  TextEditingController phonecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  void sendOTP() async {
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
    String phone = phonecontroller.text.trim();

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => verifyotp(verificationId: verificationId)));
          Fluttertoast.showToast(msg: 'OTP has been sent!');
        },
        verificationCompleted: (Credential) {},
        verificationFailed: (ex) {
          if (ex.code.toString() == 'invalid-phone-number') {
            Fluttertoast.showToast(msg: 'invalid phone number');
            Navigator.of(context).pop();
          } else if (ex.code.toString() == 'too-many-requests') {
            Fluttertoast.showToast(msg: 'too many requests');
            Navigator.of(context).pop();
          }

          log(ex.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 30));
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
        title: const Text('Phone',
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
                  controller: phonecontroller,
                  // keyboardType: TextInputType.number,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Please Enter Phone Number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: 'Phone',
                    hintText: 'e.g +92xxxxxxxxx',
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
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.only(
                                left: 70, right: 70, top: 15, bottom: 15),
                            shadowColor: Colors.black,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
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
                            sendOTP();
                          }
                        },
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
