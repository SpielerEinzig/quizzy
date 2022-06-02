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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/bottom_navigation_bar/home_icon.png",
              height: 36.68,
              width: 36.68,
              color: selectedIndex == 0 ? kDefaultColor : Colors.grey[400],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/bottom_navigation_bar/withdraw_icon.png",
              height: 36.68,
              width: 36.68,
              color: selectedIndex == 1 ? kDefaultColor : Colors.grey[400],
            ),
            label: 'Withdraw',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/bottom_navigation_bar/leaderboard_icon.png",
              height: 36.68,
              width: 36.68,
              color: selectedIndex == 2 ? kDefaultColor : Colors.grey[400],
            ),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/bottom_navigation_bar/profile_icon.png",
              height: 36.68,
              width: 36.68,
              color: selectedIndex == 3 ? kDefaultColor : Colors.grey[400],
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        selectedLabelStyle: const TextStyle(fontSize: 10),
        onTap: _onItemTapped,
      ),
    );
  }
}
