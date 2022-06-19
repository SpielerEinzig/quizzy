import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

Widget waitingScreenWidget({required String bottomText}) {
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        )),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AvatarGlow(
            endRadius: 82,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 39),
          Text(
            bottomText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
