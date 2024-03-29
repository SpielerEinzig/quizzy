import 'package:flutter/material.dart';

Widget tournamentPairCard({
  required String firstPlayer,
  required String secondPlayer,
  required double width,
  required double height,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      image: const DecorationImage(
        image: AssetImage("assets/images/tournament_icons/tournamentcard.png"),
        fit: BoxFit.cover,
      ),
    ),
    child: Stack(
      children: [
        Container(
          alignment: const Alignment(-0.85, -0.85),
          child: Text(
            firstPlayer.length <= 6
                ? firstPlayer
                : "${firstPlayer.substring(0, 6)}..",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Container(
          alignment: const Alignment(0.85, -0.85),
          child: Text(
            secondPlayer.length <= 6
                ? secondPlayer
                : "${secondPlayer.substring(0, 6)}..",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  );
}
