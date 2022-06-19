import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

Widget userScoreRibbon({
  required double x,
  required double y,
  required double width,
  required double height,
  required int position,
  required String name,
  required String score,
}) {
  double fontSize = 18;
  double heightSubtract = height;

  if (position == 1) {
    fontSize = 24;
    heightSubtract = height;
  } else if (position == 2) {
    fontSize = 18;
    height = height + 21;
  } else if (position == 3) {
    fontSize = 18;
    height = height - 5;
  } else if (position == 4) {
    fontSize = 18;
    height = height + 10;
  }
  return coOrdinatedWidget(
    x: x,
    y: y,
    widget: Container(
      //color: Colors.red,
      width: width,
      height: height + 43,
      child: Container(
        width: width,
        height: heightSubtract,
        decoration: BoxDecoration(
          //color: Colors.blue,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(
                "assets/images/tournament_result/tournament$position.png"),
          ),
        ),
        child: Stack(
          children: [
            Container(
              alignment: const Alignment(0.1, 0.6),
              child: Text(
                score,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
                alignment: const Alignment(0.1, 1),
                child:
                    Text(name.length > 6 ? "${name.substring(0, 6)}.." : name)),
          ],
        ),
      ),
    ),
  );
}

Widget bottomAvatarGlow(
    {required double x, required double y, required String centerText}) {
  return coOrdinatedWidget(
    x: x,
    y: y,
    widget: Container(
      alignment: const Alignment(0, 0.99),
      child: AvatarGlow(
        glowColor: const Color(0xFF7B5CF3),
        endRadius: 66,
        child: CircleAvatar(
          backgroundColor: const Color(0xFF7B5CF3),
          radius: 42,
          child: Center(
              child: Text(
            centerText, //_start.toString(),
            style: const TextStyle(fontSize: 47, color: Colors.white),
          )),
        ),
      ),
    ),
  );
}

Widget greatJobThumbsUp({required double x, required double y}) {
  return coOrdinatedWidget(
    x: x,
    y: y,
    widget: Container(
      height: 138,
      width: 204,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image:
              AssetImage("assets/images/tournament_result/thumbGreatJob.png"),
        ),
      ),
    ),
  );
}

Widget coOrdinatedWidget(
    {required double x, required double y, required Widget widget}) {
  return Container(
    alignment: Alignment(x, y),
    child: widget,
  );
}
