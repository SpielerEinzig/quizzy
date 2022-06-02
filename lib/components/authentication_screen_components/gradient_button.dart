import 'package:flutter/material.dart';

Widget gradientButton({
  required String label,
  required context,
  required Function()? onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      gradient: const LinearGradient(
        colors: [
          Color(0xff7B5CF3),
          Color(0xff5F9EF3),
        ],
      ),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Text(label),
      ),
      style: ElevatedButton.styleFrom(
        //primary: const Color(0xff7b5cf2),
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  );
}
