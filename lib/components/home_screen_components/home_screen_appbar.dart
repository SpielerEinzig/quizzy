import 'package:flutter/material.dart';

import '../../constants.dart';

Widget mainScreenAppBar({
  required Function() notificationButtonPressed,
  required Function() menuButtonPressed,
  required BuildContext context,
}) {
  return Container(
    alignment: Alignment.topCenter,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff7B5CF3),
            Color(0xff5F9EF3),
          ]),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(kDefaultBorderRadius),
        bottomRight: Radius.circular(kDefaultBorderRadius),
      ),
    ),
    height: MediaQuery.of(context).size.height * 0.15,
    // child: Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     TextButton(
    //       onPressed: menuButtonPressed,
    //       child: const Icon(
    //         Icons.menu,
    //         size: 40,
    //         color: Colors.white,
    //       ),
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         iconAvatar(
    //           radius: 20,
    //         ),
    //         const SizedBox(width: 2),
    //         const Text(
    //           "uizzy",
    //           style: TextStyle(
    //             fontSize: 40,
    //             letterSpacing: 2,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ],
    //     ),
    //     TextButton(
    //       onPressed: notificationButtonPressed,
    //       child: Container(
    //         width: 50,
    //         height: 50,
    //         decoration: BoxDecoration(
    //           color: Colors.grey.shade200.withOpacity(0.2),
    //           borderRadius: BorderRadius.circular(kDefaultBorderRadius),
    //         ),
    //         child: const Icon(
    //           Icons.notifications,
    //           color: Colors.white,
    //           size: 40,
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
  );
}
