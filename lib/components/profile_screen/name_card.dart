import 'package:flutter/material.dart';

Widget profileNameCard({
  required String title,
  required String value,
}) {
  return Container(
    height: 70,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey[700], fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )
      ],
    ),
  );
}
