import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';

class CreatePassword extends StatefulWidget {
  static const id = "createPassword";

  const CreatePassword({Key? key}) : super(key: key);

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  String password = "";
  String confirmPassword = "";

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
              "Create new Password",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your new password must be different from\n"
              "previous used passwords.\n",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              onChanged: (value) {
                confirmPassword = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Confirm Password",
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                //implement reset password
                Navigator.pushNamed(context, HomeScreen.id);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  "Reset Password",
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
