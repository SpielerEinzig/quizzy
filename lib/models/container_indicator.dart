import 'package:flutter/material.dart';

class ContainerIndicatorModel {
  Color color;

  ContainerIndicatorModel({required this.color});

  questionIndicator() {
    return Container(
      width: 30,
      height: 8,
      color: color,
    );
  }
}
