import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizzy/components/countdown_screen_widget.dart';

import 'matching_friends_questions_page.dart';

class MatchingFriendsCountdown extends StatefulWidget {
  final String gameId;
  final bool createdGame;
  const MatchingFriendsCountdown(
      {Key? key, required this.gameId, required this.createdGame})
      : super(key: key);

  @override
  State<MatchingFriendsCountdown> createState() =>
      _MatchingFriendsCountdownState();
}

class _MatchingFriendsCountdownState extends State<MatchingFriendsCountdown> {
  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          _timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MatchingFriendQuestionsPage(
                  gameId: widget.gameId, createdGame: widget.createdGame),
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
      body: countdownScreenWidget(
        countdownInt: _start,
        bottomText: "Countdown",
      ),
    );
  }
}
