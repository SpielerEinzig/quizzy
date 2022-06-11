import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/single_match/single_match_questions_page.dart';

class SingleMatchCountdown extends StatefulWidget {
  final String gameId;
  final bool createdGame;
  const SingleMatchCountdown({Key? key,
    required this.gameId,
    required this.createdGame,
  }) : super(key: key);

  @override
  State<SingleMatchCountdown> createState() => _SingleMatchCountdownState();
}

class _SingleMatchCountdownState extends State<SingleMatchCountdown> {
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
                      SingleMatchQuestionsPage(gameId: widget.gameId,
                          createdGame: widget.createdGame),
              ),
          );
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
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
