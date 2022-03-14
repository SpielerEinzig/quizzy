import 'package:flutter/material.dart';

import '../../constants.dart';

Widget statusCardIcon({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Column(
    children: [
      Icon(
        icon,
        color: kDefaultColor,
        size: 40,
      ),
      Text(label),
      Text(
        value,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
    ],
  );
}
