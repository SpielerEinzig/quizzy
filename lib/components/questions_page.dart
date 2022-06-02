import 'package:flutter/material.dart';

Widget answerCard({
  required String answer,
  required Function() onPressed,
  required Color? color,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: Text(
        answer,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    ),
  );
}

Widget exitButton({
  required Function() onPressed,
  required String label,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 133,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    ),
  );
}

class AnswerModel {
  String answer;
  Color? color;

  AnswerModel({required this.answer, required this.color});
}
