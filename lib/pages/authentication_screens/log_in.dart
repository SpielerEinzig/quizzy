import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/social_sign_in_button.dart';
import 'package:quizzy/pages/authentication_screens/sign_up.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/main_screen.dart';

import 'forgot_password.dart';

class LogIn extends StatefulWidget {
  static const String id = "logIn";

  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "";
  String password = "";

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(child: SizedBox(height: 30)),
            RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "WELCOME!\n",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: "\nLogin to your account",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const Flexible(child: SizedBox(height: 60)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () async {
                    print("Username: $email\nPassword: $password");
                    try {
                      final loggedInUser =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      if (loggedInUser != null) {
                        Navigator.pushNamed(context, HomeScreen.id);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Text("Log In"),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff7b5cf2),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ForgotPassword.id);
                  },
                  child: const Text("Forgot password?"),
                ),
              ],
            ),
            //const SizedBox(height: 40),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  socialSignInButton(
                    label: "Facebook",
                    imageUrl: "assets/images/social_icons/facebook.png",
                    onPressed: () {
                      print("Facebook sign in");
                    },
                  ),
                  socialSignInButton(
                    label: "Google",
                    imageUrl: "assets/images/social_icons/google.png",
                    onPressed: () {
                      print("Google sign in");
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not having account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUp.id);
                  },
                  child: const Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
