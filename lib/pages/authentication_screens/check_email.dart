import 'package:flutter/material.dart';
import 'package:quizzy/pages/authentication_screens/create_password.dart';

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
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                flex: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 100),
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
                        const SizedBox(height: 100),
                        const Text(
                          "Check Your Email",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "We have send a password recover\n"
                          "       instructions to your email.",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //implement functionality
                        print("do it");
                        Navigator.pushNamed(context, CreatePassword.id);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Text("Open Email"),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff7b5cf2),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
              ),
              Expanded(
                child: Center(
                  child: Column(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
