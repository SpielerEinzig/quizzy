import 'package:flutter/material.dart';
import 'package:quizzy/components/authentication_screen_components/gradient_button.dart';

import 'forgot_password.dart';
import 'log_in.dart';

class CheckEmail extends StatefulWidget {
  static const String id = "checkEmail";

  const CheckEmail({Key? key}) : super(key: key);

  @override
  _CheckEmailState createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 18, right: 18, left: 18, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Container(
                height: 182,
                width: 182,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: const Center(
                  child: Icon(
                    Icons.email,
                    color: Color(0xff7b5cf2),
                    size: 100,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Check Your Email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "We have send a password recover",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    "instructions to your email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 50),
                  gradientButton(
                      label: "Open Email",
                      context: context,
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(LogIn.id);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        //implement i'll come back later
                        Navigator.popAndPushNamed(context, LogIn.id);
                      },
                      child: const Text(
                        "Skip, I'll come back later",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Did not receive the email? Check your spam"),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, ForgotPassword.id);
                    },
                    child: const Text("or try another email address"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
