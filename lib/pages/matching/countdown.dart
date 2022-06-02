import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/questions_page.dart';

class CountDownPage extends StatefulWidget {
  static const String id = "countDownPage";

  String roomName;

  CountDownPage({Key? key, required this.roomName}) : super(key: key);

  @override
  _CountDownPageState createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionsPage(roomName: widget.roomName)));
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.roomName);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff7A5CF3),
                Color(0xff658EF3),
              ]),
        ),
        child: Stack(
          children: [
            Center(
              child: AvatarGlow(
                endRadius: 82,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 52,
                  child: Center(
                      child: Text(
                    _start.toString(),
                    style: const TextStyle(
                      fontSize: 47,
                    ),
                  )),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                alignment: const Alignment(0, 0.4),
                child: const Text(
                  "Countdown",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
