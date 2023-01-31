import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app_flutter/Screens/HomePage.dart';

import 'Login_Screen.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({Key? key}) : super(key: key);

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> with TickerProviderStateMixin {
  //Animation Controller
  late final AnimationController controllerr = AnimationController(
      duration: const Duration(milliseconds: 3000), vsync: this)
    ..repeat();
  //Declare a Variables
  final formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController cpasscontroller = TextEditingController();

  // Create a function for create a User
  void createAccounts() async {
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();
    String cPassword = cpasscontroller.text.trim();

    if (password != cPassword) {
      Fluttertoast.showToast(msg: "password doesn't match");
    } else if (password.length < 6) {
      Fluttertoast.showToast(msg: "password length should be >=6");
    } else {
      try {
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
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Fluttertoast.showToast(msg: "Account Sucessfully Created!");

        if (userCredential.user != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Homepage()),
              (route) => false);
        }
      } on FirebaseAuthException catch (ex) {
        if (ex.code == "email-already-in-use") {
          Fluttertoast.showToast(msg: "Email already exist!");
        } else if (ex.code == "invalid-email") {
          Fluttertoast.showToast(msg: "Invalid Email");
        }
      }
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
          'Sign Up',
          style: TextStyle(fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 23, right: 23, top: 20),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    'Assets/Images/signup.png',
                    width: 360,
                    height: 210,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (String? text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Your UserName';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passcontroller,
                    validator: (String? text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: const Icon(Icons.visibility_off),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: cpasscontroller,
                    validator: (String? text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Confirm Password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: const Icon(Icons.visibility_off),
                      labelText: 'Confirm Password',
                      hintText: 'Enter Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Already have an Account?',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17))),
                  const SizedBox(height: 25),
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
                              createAccounts();
                            }
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
