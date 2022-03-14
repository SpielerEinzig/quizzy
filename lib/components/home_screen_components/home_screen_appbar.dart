import 'package:flutter/material.dart';

import '../../constants.dart';
import '../icon_avatar.dart';

AppBar homeScreenAppBar({required Function() notificationButtonPressed}) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    backgroundColor: kDefaultColor,
    leading: TextButton(
      onPressed: () {},
      child: const Icon(
        Icons.menu,
        size: 40,
        color: Colors.white,
      ),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconAvatar(radius: 20),
        const Text(
          "uizzy",
          style: TextStyle(
            fontSize: 40,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: notificationButtonPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    ],
  );
}
