import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/main_screen.dart';

import '../../components/social_sign_in_button.dart';
import '../home_screen/home_screen.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {
  static const id = "signup";

  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String password = "";
  String fullName = "";

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "WELCOME!\n",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "\nCreate a new account",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LogIn.id);
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  onChanged: (value) {
                    fullName = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Full Name",
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    //check if email and full name is not empty
                    //and password length is greater than 6
                    if (email.isNotEmpty &&
                        fullName.isNotEmpty &&
                        password.length >= 6) {
                      //creating new user with firebase
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        //get userId
                        User? loggedInUser;
                        final user = _auth.currentUser;

                        if (user != null) {
                          loggedInUser = user;
                        }
                        //create user model with fireStore
                        _fireStore
                            .collection("users")
                            .doc(loggedInUser!.uid)
                            .set({
                          "name": fullName,
                          "email": email,
                        });

                        //check if user is null before moving to next screen
                        if (newUser != null) {
                          //navigate to main screen
                          Navigator.pushNamed(context, HomeScreen.id);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    } else if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Provide an email"),
                      ));
                    } else if (fullName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Provide your name"),
                      ));
                    } else if (password.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Password should be greater than 6 characters"),
                      ));
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Text("Sign Up"),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff7b5cf2),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            //const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                socialSignInButton(
                  label: "Facebook",
                  imageUrl: "assets/images/social_icons/facebook.png",
                  onPressed: () {
                    //implement sign up with social media
                    print("Facebook sign up");
                  },
                ),
                socialSignInButton(
                  label: "Google",
                  imageUrl: "assets/images/social_icons/google.png",
                  onPressed: () {
                    print("Google sign up");
                  },
                ),
              ],
            ),
            Column(
              children: [
                const Text("By continuing, you agree to our"),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        //implement terms and conditions
                        print("terms and conditions");
                      },
                      child: const Text("Terms & conditions"),
                    ),
                    const Text("  &  "),
                    TextButton(
                      onPressed: () {
                        //implement privacy policy
                        print("Privacy policy");
                      },
                      child: const Text("Privacy policy"),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}