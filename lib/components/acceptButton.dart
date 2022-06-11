import 'package:flutter/material.dart';

import '../constants.dart';

Widget acceptButton({required Function() onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Container(
      width: 85,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: const Color(0xffE1E3FC),
      ),
      child: const Center(
        child: Text(
          "Accept",
          style: TextStyle(
            fontSize: 15,
            color: kDefaultColor,
          ),
        ),
      ),
    ),
  );
}
