import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/profile_screen/name_card.dart';
import 'package:quizzy/services/location.dart';

import '../../components/gradient_appbar.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "profileScreen";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String location = "";

  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void getUserModel() async {
    final userModel = await FirebaseFirestore.instance
        .collection("users")
        .doc(loggedInUser!.uid)
        .get();

    if (userModel.exists) {
      Map<String, dynamic> data = userModel.data()!;

      // You can then retrieve the value from the Map like this:
      setState(() {
        name = data['name'];
        email = data["email"];
        location = data["location"];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              mainPageAppBars(context: context, title: "Profile"),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 140,
            child: Container(
              height: 360,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              LocationService()
                                  .getCurrentLocation(context: context);
                            },
                            child: Text(
                              "Change profile picture",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  profileNameCard(title: "First Name", value: name),
                  profileNameCard(
                      title: "Email", value: "${loggedInUser?.email}"),
                  profileNameCard(title: "Location", value: location),
                ],
              ),
            ),
          ),
          Container(
            alignment: const Alignment(-0.76, -0.65),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
