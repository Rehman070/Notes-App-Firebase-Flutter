import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app_flutter/Screens/HomePage.dart';
import 'package:notes_app_flutter/Screens/Login_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('Assets/Images/notepad.json'),
      nextScreen: (FirebaseAuth.instance.currentUser != null)
          ? const Homepage()
          : const LoginScreen(),
      duration: 3000,
      centered: true,
      backgroundColor: const Color.fromARGB(255, 103, 173, 230),
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 1000),
      splashIconSize: 270,
    );
  }
}
