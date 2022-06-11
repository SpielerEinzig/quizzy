import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/authentication_screen_components/gradient_button.dart';
import 'package:quizzy/pages/authentication_screens/check_email.dart';

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
      resizeToAvoidBottomInset: false,
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
                  Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Back",
                    style: TextStyle(color: Colors.black),
                  ),
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
            gradientButton(
              context: context,
              label: "Send Instructions",
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
                  Navigator.popAndPushNamed(context, CheckEmail.id);
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
            ),
          ],
        ),
      ),
    );
  }
}
