import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/tournament/tournamentQuestions.dart';

import '../../../components/tournament_pair_card.dart';

class TournamentCountDown extends StatefulWidget {
  final List usersInRoom;
  final String gameRoom;

  const TournamentCountDown({
    Key? key,
    required this.usersInRoom,
    required this.gameRoom,
  }) : super(key: key);

  @override
  _TournamentCountDownState createState() => _TournamentCountDownState();
}

class _TournamentCountDownState extends State<TournamentCountDown> {
  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TournamentQuestionsPage(roomName: widget.gameRoom)));
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    List usersInTournamentRoom = widget.usersInRoom;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: screenHeight * 0.34,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff7A5CF3),
                      Color(0xff658EF3),
                    ]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: SafeArea(
              child: Column(
                children: [
                  AvatarGlow(
                    endRadius: 82,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50,
                      child: Center(
                          child: Text(
                        _start.toString(),
                        style: const TextStyle(
                          fontSize: 47,
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      "Countdown",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 355,
            //color: Colors.red,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 19,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                tournamentPairCard(
                  firstPlayer: usersInTournamentRoom.isNotEmpty
                      ? usersInTournamentRoom[0].name
                      : "Waiting",
                  secondPlayer: usersInTournamentRoom.length >= 2
                      ? usersInTournamentRoom[1].name
                      : "Waiting",
                  width: screenWidth * 0.44,
                  height: screenHeight * 0.23,
                ),
                tournamentPairCard(
                  firstPlayer: usersInTournamentRoom.length >= 3
                      ? usersInTournamentRoom[2].name
                      : "Waiting",
                  secondPlayer: usersInTournamentRoom.length >= 4
                      ? usersInTournamentRoom[3].name
                      : "Waiting",
                  width: screenWidth * 0.44,
                  height: screenHeight * 0.23,
                ),
                tournamentPairCard(
                  firstPlayer: usersInTournamentRoom.length >= 5
                      ? usersInTournamentRoom[4].name
                      : "Waiting",
                  secondPlayer: usersInTournamentRoom.length >= 6
                      ? usersInTournamentRoom[5].name
                      : "Waiting",
                  width: screenWidth * 0.44,
                  height: screenHeight * 0.23,
                ),
                tournamentPairCard(
                  firstPlayer: usersInTournamentRoom.length >= 7
                      ? usersInTournamentRoom[6].name
                      : "Waiting",
                  secondPlayer: usersInTournamentRoom.length >= 8
                      ? usersInTournamentRoom[7].name
                      : "Waiting",
                  width: screenWidth * 0.44,
                  height: screenHeight * 0.23,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
