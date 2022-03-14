import 'package:flutter/material.dart';

const kDefaultColor = Color(0xff7b5cf2);

class NotificationList {
  String name;
  bool accepted;
  NotificationList({required this.name, required this.accepted});
}

// created objects for quiz categories
class QuizCategory {
  IconData icon;
  String label;
  QuizCategory({required this.label, required this.icon});
}

//list of quiz categories
List<QuizCategory> quizCategoryList = [
  QuizCategory(label: "Science", icon: Icons.rocket_launch),
  QuizCategory(label: "Geography", icon: Icons.public),
  QuizCategory(label: "Technology", icon: Icons.tv),
  QuizCategory(label: "Travel", icon: Icons.airplanemode_active),
  QuizCategory(label: "Music", icon: Icons.music_note),
  QuizCategory(label: "Art", icon: Icons.format_paint),
  QuizCategory(label: "Math", icon: Icons.format_underlined),
  QuizCategory(label: "Sport", icon: Icons.sports_basketball),
  QuizCategory(label: "History", icon: Icons.menu_book),
];

//created objects for people in leaderboard
class LeaderBoard {
  String name;
  int points;
  LeaderBoard({required this.name, required this.points});
}

//dummy list of top leaderboard
List<LeaderBoard> leaderBoardList = [
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
  LeaderBoard(name: "Adam", points: 5260),
];

Widget labelValueColumn({
  required String label,
  required String value,
}) {
  return Column(
    children: [
      Text(label),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}
