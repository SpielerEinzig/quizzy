import 'package:flutter/material.dart';

import '../constants.dart';

class AppbarContainer extends StatelessWidget {
  final String title;

  const AppbarContainer({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff7B5CF3),
              Color(0xff658CF3),
            ]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.2),
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}

Widget mainPageAppBars({
  required BuildContext context,
  required String title,
}) {
  return Container(
    alignment: const Alignment(0, -0.25),
    height: MediaQuery.of(context).size.height * 0.25,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff7B5CF3),
            Color(0xff658CF3),
          ]),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(kDefaultBorderRadius),
        bottomRight: Radius.circular(kDefaultBorderRadius),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.white,
      ),
    ),
  );
}