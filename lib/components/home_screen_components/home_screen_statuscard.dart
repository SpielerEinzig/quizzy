import 'package:flutter/material.dart';

import 'home_screen_statuscardicons.dart';

Widget homeScreenStatusCard({
  required int point,
  required int worldRank,
  required int localRank,
}) {
  return Positioned(
    left: 0,
    right: 0,
    top: 30,
    child: Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 50,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          statusCardIcon(
              icon: Icons.star, label: "POINT", value: point.toString()),
          const VerticalDivider(),
          statusCardIcon(
              icon: Icons.public,
              label: "WORLD RANK",
              value: worldRank.toString()),
          const VerticalDivider(),
          statusCardIcon(
              icon: Icons.location_on,
              label: "LOCAL RANK",
              value: localRank.toString()),
        ],
      ),
    ),
  );
}
