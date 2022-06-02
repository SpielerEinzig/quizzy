import 'package:flutter/material.dart';

Widget iconAvatar({required double radius}) {
  return CircleAvatar(
    radius: radius,
    backgroundImage: const AssetImage("assets/images/icon.PNG"),
  );
}
