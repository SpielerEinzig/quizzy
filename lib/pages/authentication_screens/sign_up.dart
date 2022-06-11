import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/authentication_screen_components/gradient_button.dart';
import 'package:quizzy/services/authentication.dart';
import 'package:quizzy/services/database.dart';
import 'package:quizzy/services/location.dart';

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
  String location = "";

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  final AuthenticationService authenticationService = AuthenticationService();
  final LocationService locationService = LocationService();
  final DataBaseService databaseService = DataBaseService();

  bool signingUserIn = false;

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "Hi!\n",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: "\nCreate a new account",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
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
                              fontSize: 20,
                              decoration: TextDecoration.underline,
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
                            contentPadding: EdgeInsets.only(left: 30),
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
                        const SizedBox(height: 50),
                        gradientButton(
                          context: context,
                          label: "Sign Up",
                          onPressed: () async {
                            //check if email and full name is not empty
                            //and password length is greater than 6
                            final getLocation = await locationService
                                .getCurrentLocation(context: context);

                            location = getLocation!;

                            if (email.isNotEmpty &&
                                fullName.isNotEmpty &&
                                password.length >= 6) {
                              //creating new user with firebase
                              try {
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
                                  "point": 0,
                                  "location": location,
                                  "connecting": false,
                                  "inGame": false,
                                });
                                //navigate to main screen

                                Navigator.popAndPushNamed(
                                    context, HomeScreen.id);
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(e.toString()),
                                ));
                              }
                            } else if (email.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Provide an email"),
                              ));
                            } else if (fullName.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Provide your name"),
                              ));
                            } else if (password.length < 6) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Password should be greater than 6 characters"),
                              ));
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    //const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: socialSignInButton(
                            label: "Facebook",
                            imageUrl: "assets/images/social_icons/facebook.png",
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
                                  SnackBar(content: Text("Error with location service: ${e.toString()}"),),);
                              }
                              //authenticate and register user
                              try {
                                await authenticationService
                                    .signInWithGoogle()
                                    .then((user) => {
                                          databaseService.registerFirestoreUser(
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
                              },
                              child: const Text("Terms & conditions"),
                            ),
                            const Text("  &  "),
                            TextButton(
                              onPressed: () {
                                //implement privacy policy
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
      ),
    );
  }
}
