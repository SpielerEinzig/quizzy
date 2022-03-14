import 'package:flutter/material.dart';

import '../../constants.dart';

Widget inviteFriend({required Function() onTapped}) {
  return GestureDetector(
    onTap: onTapped,
    child: Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 50,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.person_add,
            size: 80,
            color: kDefaultColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Play With a Friend",
                style: TextStyle(
                  fontSize: 18,
                  color: kDefaultColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Invite Your Friend\nTo Start Quiz With You",
                style: TextStyle(
                  fontSize: 15,
                  color: kDefaultColor,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: kDefaultColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: kDefaultColor,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
