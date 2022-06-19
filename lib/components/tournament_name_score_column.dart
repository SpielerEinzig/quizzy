import 'package:flutter/material.dart';

Widget positionedScoreNamePair({
  required int score,
  required String name,
  required double height,
  required double scoreFontSize,
  required double nameFontSize,
}) {
  return SizedBox(
    height: height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          score.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: scoreFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          name.length > 5 ? "${name.substring(0, 5)}.." : name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: nameFontSize,
          ),
        ),
      ],
    ),
  );
}
