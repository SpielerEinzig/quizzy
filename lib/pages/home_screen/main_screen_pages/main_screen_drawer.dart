import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/constants.dart';

import '../../../components/icon_avatar.dart';
import '../../authentication_screens/log_in.dart';

class MainScreenDrawer extends StatefulWidget {
  const MainScreenDrawer({Key? key}) : super(key: key);

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kDefaultColor,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kDefaultColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconAvatar(width: 45, height: 45),
                const SizedBox(width: 2),
                const Text(
                  "uizzy",
                  style: TextStyle(
                    fontSize: 40,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onTap: () async {
              // Update the state of the app
              await _auth.signOut();
              // Then close the drawer
              Navigator.pushReplacementNamed(context, LogIn.id);
            },
          ),
          // ListTile(
          //   title: const Text('Item 2'),
          //   onTap: () {
          //     // Update the state of the app
          //     // ...
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
