import 'package:flutter/material.dart';

Widget socialSignInButton({
  required String label,
  required String imageUrl,
  required Function() onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          CircleAvatar(
            //backgroundImage: AssetImage(label),
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.white70,
    ),
  );
}
