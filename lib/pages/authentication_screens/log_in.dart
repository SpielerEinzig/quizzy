import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/authentication_screen_components/gradient_button.dart';
import 'package:quizzy/components/social_sign_in_button.dart';
import 'package:quizzy/pages/authentication_screens/sign_up.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/services/database.dart';
import 'package:quizzy/services/location.dart';

import '../../services/authentication.dart';
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
  String location = "";

  final _auth = FirebaseAuth.instance;

  final AuthenticationService authenticationService = AuthenticationService();
  final LocationService locationService = LocationService();
  final DataBaseService databaseService = DataBaseService();

  bool signingUserIn = false;

  @override
  Widget build(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(LogIn.id));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: signingUserIn == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
                            text: "Welcome!\n",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextSpan(
                            text: "\nLogin to your account",
                            style: TextStyle(fontSize: 20, color: Colors.black),
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
                            contentPadding: EdgeInsets.only(left: 30),
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
                            contentPadding: EdgeInsets.only(left: 30),
                          ),
                        ),
                        const SizedBox(height: 80),
                        gradientButton(
                          context: context,
                          label: "Log In",
                          onPressed: () async {
                            try {
                              final loggedInUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.id);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
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
                          Flexible(
                            child: socialSignInButton(
                              label: "Facebook",
                              imageUrl:
                                  "assets/images/social_icons/facebook.png",
                              onPressed: () async {
                                setState(() {
                                  signingUserIn = true;
                                });
                                //get user location
                                try {
                                  final getLocation = await locationService
                                      .getCurrentLocation(context: context);

                                  location = getLocation!;
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())));
                                }
                                //authenticate and register user
                                try {
                                  await authenticationService
                                      .signInWithFacebook()
                                      .then((user) {
                                    databaseService.registerFirestoreUser(
                                      user: user,
                                      context: context,
                                      location: location,
                                    );
                                  });
                                } catch (e) {
                                  if (e is FirebaseAuthException) {
                                    // Show error widget
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                }
                                setState(() {
                                  signingUserIn = false;
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: socialSignInButton(
                              label: "Google",
                              imageUrl: "assets/images/social_icons/google.png",
                              onPressed: () async {
                                //get user location
                                try {
                                  final getLocation = await locationService
                                      .getCurrentLocation(context: context);

                                  location = getLocation!;
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {
                                  signingUserIn = true;
                                });
                                //authenticate and register user
                                try {
                                  await authenticationService
                                      .signInWithGoogle()
                                      .then((user) => {
                                            databaseService
                                                .registerFirestoreUser(
                                              user: user,
                                              context: context,
                                              location: location,
                                            ),
                                          });
                                } catch (e) {
                                  if (e is FirebaseAuthException) {
                                    // Show error widget
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                }
                                setState(() {
                                  signingUserIn = false;
                                });
                              },
                            ),
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
                            Navigator.popAndPushNamed(context, SignUp.id);
                          },
                          child: const Text("Sign up"),
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
