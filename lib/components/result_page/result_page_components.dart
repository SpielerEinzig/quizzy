import 'package:flutter/material.dart';

String loremText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    " Integer dolor eget eget arcu varius. Mauris, proin ac rutrum";

int playerScore = 8832;

Widget shareCard({required context, required Function() onPressed}) {
  return Container(
    alignment: const Alignment(0, 0.9),
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1198,
        padding: const EdgeInsets.only(left: 20, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xff658EF3),
              Color(0xff7A5EF3),
            ],
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.share,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Share with friends",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Help your friends fall in love with \nlearning through Quizzy!",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget badgeScore({required int score, required String imagePath}) {
  return Container(
    alignment: const Alignment(0, -0.63),
    child: Stack(
      children: [
        Container(
          alignment: const Alignment(0, -0.63),
          child: Image.asset(
            "assets/images/results_page/ribbon.png",
            height: 150,
            width: 200,
          ),
        ),
        Container(
          alignment: const Alignment(0.009, -0.65),
          child: const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.transparent,
          ),
        ),
        Container(
          alignment: const Alignment(-0.3, -0.7),
          child: Image.asset(
            imagePath,
            height: 60,
            width: 60,
          ),
        ),
        Container(
          alignment: const Alignment(0, -0.4),
          child: Text(
            score.toString(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
