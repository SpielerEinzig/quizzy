import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/authentication_screens/check_email.dart';
import 'package:quizzy/pages/authentication_screens/log_in.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = "forgotPassword";

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 6),
                  Text("Back"),
                ],
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter the email associated with your\n"
              "account and we’ll send an email with\n"
              "instructions to reset your password.\n",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                //send password reset link
                try {
                  await _auth.sendPasswordResetEmail(email: email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Instructions sent to mail"),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 6));
                  Navigator.popAndPushNamed(context, LogIn.id);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                      ),
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  "Send Instructions",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff7b5cf2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
