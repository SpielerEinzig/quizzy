import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const kDefaultColor = Color(0xff7b5cf2);
const double kDefaultBorderRadius = 10;
const double kStackPositioning = 150;

List<String> botNames = [
  "Ali",
  "Muhammad",
  "Yusuf",
  "Bilal",
  "Hamza",
  "Mariam",
  "Ayesha",
  "Fatima",
];

class NotificationList {
  String name;
  String senderUid;
  bool valid;
  DateTime timeSent;
  NotificationList({
    required this.name,
    required this.senderUid,
    required this.valid,
    required this.timeSent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationList &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          senderUid == other.senderUid &&
          valid == other.valid &&
          timeSent == other.timeSent;

  @override
  int get hashCode => name.hashCode;
}

Widget labelValueColumn({
  required String label,
  required String value,
}) {
  return Column(
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      )
    ],
  );
}
