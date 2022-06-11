
import 'package:flutter/material.dart';

import '../../constants.dart';

Widget inviteFriend({required Function() onTapped}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 10),
          blurRadius: 50,
          color: Colors.black.withOpacity(0.2),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/friend.png",
              height: 60,
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Play With a Friend",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Invite Your Friend to Start Quiz\nWith You",
                  style: TextStyle(
                    fontSize: 11,
                    //color: kDefaultColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            TextButton(
              onPressed: onTapped,
              child: const Text(
                "Add a Friend",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
