import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app_flutter/Screens/HomePage.dart';
import 'package:notes_app_flutter/Screens/Signup_Screen.dart';
import 'Signin_Phone_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  //Animation Controller
  late final AnimationController controllerr = AnimationController(
      duration: const Duration(milliseconds: 3000), vsync: this)
    ..repeat();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  void signin() async {
    String email = emailcontroller.text.trim();
    String password = passcontroller.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(msg: "Sucessfully Login!");

      if (userCredential.user != null) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const Homepage()),
            (route) => false);
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == "invalid-email") {
        Fluttertoast.showToast(msg: "invalid email");
      } else if (ex.code == "wrong-password") {
        Fluttertoast.showToast(msg: "wrong password");
      } else if (ex.code == "user-not-found") {
        Fluttertoast.showToast(msg: "user no found");
      }
    }
  }

  void signinwithGoogle() async {
    GoogleSignIn googlesignin = GoogleSignIn();

    try {
      const Center(
          child: SpinKitSpinningLines(
        color: Colors.black,
        duration: Duration(seconds: 3),
        size: 60,
        
      ));
      GoogleSignInAccount? account = await googlesignin.signIn();
      if (account == null) {
        return;
      } else {
        final userdata = await account.authentication;
        final credenial = GoogleAuthProvider.credential(
            accessToken: userdata.accessToken, idToken: userdata.idToken);
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credenial);
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => const Homepage()),
            (route) => false);
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
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
                //crossAxisAlignment: CrossAxisAlignment.end,

                children: <Widget>[
                  Image.asset(
                    'Assets/Images/login.png',
                    width: 360,
                    height: 210,
                  ),
                  TextFormField(
                    controller: emailcontroller,
                    validator: (String? text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Your UserName';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) {
                            return const Sign_up();
                          }));
                        },
                        child: const Text('Create an Account?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ))),
                  ]),
                  const SizedBox(height: 20),
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
                              signin();
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (context) {
                              return const Sign_up();
                            }));
                          },
                          child: const Text('Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              )))
                    ],
                  ),
                  const Divider(
                    height: 0.5,
                    color: Colors.black38,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'sign in with other methods',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          color: Colors.green.shade400,
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => const SigninPhone()));
                          },
                          icon: const FaIcon(FontAwesomeIcons.phone)),
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: signinwithGoogle,
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                builder: (conext) => const Homepage()),
                            (route) => false);
                      },
                      child: const Text('skip for now >>',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 21,
                          )))
                ],
              ),
            ),
          )),
    );
  }
}
