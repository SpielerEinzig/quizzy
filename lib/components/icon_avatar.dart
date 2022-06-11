import 'package:flutter/material.dart';

Widget iconAvatar({required double width, required double height}) {
  return Container(
    height: height,
    width: width,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.red,
    ),
    child: Image.asset(
      'assets/images/circle-icon.png',
      fit: BoxFit.fill,
    ),
  );
}
