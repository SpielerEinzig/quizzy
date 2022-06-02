import 'package:flutter/material.dart';

import '../../../constants.dart';

Widget playTournamentCard({required Function() onTapped}) {
  return GestureDetector(
    onTap: onTapped,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        //height: 90,
        padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: kDefaultColor,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/trophy.png",
                  height: 70,
                ),
                const SizedBox(width: 22),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Play Quiz\nTournament",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Play in tournament\n"
                      "With other people",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
