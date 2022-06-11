import 'package:flutter/material.dart';


Widget statusCardIcon({
  required String iconPath,
  required String label,
  required String value,
}) {
  return Column(
    children: [
      Image.asset(
        iconPath,
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    ],
  );
}
