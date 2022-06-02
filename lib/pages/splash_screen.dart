import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizzy/components/icon_avatar.dart';

import 'authentication_screens/log_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LogIn.id);
    });

    return Scaffold(
      body: Container(
        color: const Color(0xff7b5cf2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 75,
                child: iconAvatar(radius: 65),
              ),
              const SizedBox(height: 10),
              const Text(
                "Quizzy",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
