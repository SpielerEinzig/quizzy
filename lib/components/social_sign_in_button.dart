import 'package:flutter/material.dart';

Widget socialSignInButton({
  required String label,
  required String imageUrl,
  required Function() onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Card(
      child: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 3),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const Flexible(child: SizedBox(width: 10)),
              Text(
                label,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
