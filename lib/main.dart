import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/authentication_screens/check_email.dart';
import 'package:quizzy/pages/authentication_screens/create_password.dart';
import 'package:quizzy/pages/authentication_screens/forgot_password.dart';
import 'package:quizzy/pages/authentication_screens/log_in.dart';
import 'package:quizzy/pages/authentication_screens/sign_up.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/pages/home_screen/leaderboard_screen.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/add_friends.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/categories.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/notifications.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/tournament.dart';
import 'package:quizzy/pages/home_screen/profile_screen.dart';
import 'package:quizzy/pages/home_screen/withdraw.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/main_screen.dart';
import 'package:quizzy/pages/matching/connecting_players.dart';
import 'package:quizzy/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      // apiKey: "AIzaSyDhPtS9QoM8ULYEPBxeeFddj7TJEMF0d_4",
      // authDomain: "quizzy-5b6e3.firebaseapp.com",
      // projectId: "quizzy-5b6e3",
      // storageBucket: "quizzy-5b6e3.appspot.com",
      // messagingSenderId: "96758563610",
      // appId: "1:96758563610:web:c2508dbc5380c3468522a3"),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins-Regular',
        primaryColor: const Color(0xff7b5cf2),
        appBarTheme: const AppBarTheme(
          color: Color(0xff7b5cf2),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        LogIn.id: (context) => const LogIn(),
        SignUp.id: (context) => const SignUp(),
        ForgotPassword.id: (context) => const ForgotPassword(),
        CheckEmail.id: (context) => const CheckEmail(),
        CreatePassword.id: (context) => const CreatePassword(),
        MainScreen.id: (context) => const MainScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        LeaderBoardScreen.id: (context) => const LeaderBoardScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        Withdraw.id: (context) => const Withdraw(),
        AddFriends.id: (context) => const AddFriends(),
        Notifications.id: (context) => const Notifications(),
        Categories.id: (context) => const Categories(),
        Tournament.id: (context) => const Tournament(),
        ConnectPlayers.id: (context) => const ConnectPlayers(),
        //CountDownPage.id: (context) => const CountDownPage(),
        //QuestionsPage.id: (context) => QuestionsPage(),
        //ResultsPage.id: (context) => ResultsPage(),
      },
    );
  }
}
