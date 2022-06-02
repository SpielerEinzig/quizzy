import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'circle_avatar.dart';

Widget singleMatchStack({
  required double screenWidth,
  required String name,
  required String secondUser,
}) {
  return Stack(
    children: [
      Container(
        alignment: const Alignment(0, -0.9),
        child: Container(
          width: screenWidth * 0.92,
          height: 101,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffEAEAFC),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Image.asset("assets/images/trophy3d.png"),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("You have earned an award"),
                      Text(
                        "Tournament winner",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: const Center(
          child: AvatarGlow(
            endRadius: 150,
            glowColor: Color(0xff6C7FF3),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xff6C7FF3),
              child: Center(
                child: Text("VS"),
              ),
            ),
          ),
        ),
      ),
      Container(
        alignment: const Alignment(0, 0.7),
        child: GestureDetector(
          onTap: () {},
          child: const Text("Connecting..."),
        ),
      ),
      avatarCircle(x: -0.5, y: -0.37),
      Container(alignment: const Alignment(-0.5, -0.22), child: Text(name)),
      avatarCircle(x: 0.5, y: 0.37),
      Container(alignment: const Alignment(0.5, 0.47), child: Text(secondUser)),
    ],
  );
}
