import 'package:flutter/material.dart';

Widget avatarCircle({
  required double x,
  required double y,
}) {
  return Container(
    alignment: Alignment(x, y),
    child: const CircleAvatar(
      backgroundColor: Color(0xff6C7FF3),
      radius: 33,
      child: FlutterLogo(),
    ),
  );
}
