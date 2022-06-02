import 'package:flutter/material.dart';
import 'package:quizzy/constants.dart';

import 'home_screen_statuscardicons.dart';

Widget homeScreenStatusCard({
  required int point,
  required int worldRank,
  required int localRank,
}) {
  return Positioned(
    left: 0,
    right: 0,
    top: 100,
    child: Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 50,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: statusCardIcon(
              iconPath: "assets/images/status_card/star.png",
              label: "POINT",
              value: point.toString(),
            ),
          ),
          const VerticalDivider(),
          statusCardIcon(
              iconPath: "assets/images/status_card/world.png",
              label: "WORLD RANK",
              value: worldRank.toString()),
          const VerticalDivider(),
          statusCardIcon(
              iconPath: "assets/images/status_card/location.png",
              label: "LOCAL RANK",
              value: localRank.toString()),
        ],
      ),
    ),
  );
}
