import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/leaderboard_screen.dart';
import 'package:quizzy/pages/home_screen/profile_screen.dart';
import 'package:quizzy/pages/home_screen/withdraw.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/main_screen.dart';

import '../../constants.dart';

class HomeScreen extends StatefulWidget {
  static const id = "homeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = [
    const MainScreen(),
    const Withdraw(),
    const LeaderBoardScreen(),
    const ProfileScreen(),
  ];

  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Withdraw',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: kDefaultColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
