import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

Widget countdownScreenWidget(
    {required int countdownInt, required String bottomText}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff7A5CF3),
            Color(0xff658EF3),
          ]),
    ),
    child: Stack(
      children: [
        Center(
          child: AvatarGlow(
            endRadius: 82,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 52,
              child: Center(
                  child: Text(
                countdownInt.toString(),
                style: const TextStyle(
                  fontSize: 47,
                ),
              )),
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            alignment: const Alignment(0, 0.4),
            child: Text(
              bottomText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
