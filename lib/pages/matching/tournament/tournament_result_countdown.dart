import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/pages/matching/tournament/tournamentResults.dart';

import '../../../components/tournament_name_score_column.dart';
import '../../../models/tournament_user.dart';

class TournamentResultCountDown extends StatefulWidget {
  List<TournamentPlayerNameScore> tournamentPlayerScore;

  TournamentResultCountDown({Key? key, required this.tournamentPlayerScore})
      : super(key: key);

  @override
  _TournamentResultCountDownState createState() =>
      _TournamentResultCountDownState();
}

class _TournamentResultCountDownState extends State<TournamentResultCountDown> {
  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          Navigator.popAndPushNamed(context, HomeScreen.id);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/tournamentresult.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Stack(
              children: [
                Container(
                  alignment: const Alignment(0, -0.48),
                  child: Text(
                    congratulationText,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: const Alignment(-0.15, 0.2),
                  child: positionedScoreNamePair(
                    score: widget.tournamentPlayerScore[0].score,
                    name: widget.tournamentPlayerScore[0].name,
                    height: 80,
                    nameFontSize: 18,
                    scoreFontSize: 24,
                  ),
                ),
                Container(
                  alignment: const Alignment(0.9, 0.06),
                  child: positionedScoreNamePair(
                    score: widget.tournamentPlayerScore[1].score,
                    name: widget.tournamentPlayerScore[1].name,
                    height: 61,
                    nameFontSize: 15,
                    scoreFontSize: 18,
                  ),
                ),
                Container(
                  alignment: const Alignment(-0.87, 0.4),
                  child: positionedScoreNamePair(
                    score: widget.tournamentPlayerScore[2].score,
                    name: widget.tournamentPlayerScore[2].name,
                    height: 61,
                    nameFontSize: 15,
                    scoreFontSize: 16,
                  ),
                ),
                Container(
                  alignment: const Alignment(0.58, 0.45),
                  child: positionedScoreNamePair(
                    score: widget.tournamentPlayerScore[3].score,
                    name: widget.tournamentPlayerScore[3].name,
                    height: 61,
                    nameFontSize: 15,
                    scoreFontSize: 14,
                  ),
                ),
                Container(
                  alignment: const Alignment(0, 0.99),
                  child: AvatarGlow(
                    glowColor: const Color(0xFF7B5CF3),
                    endRadius: 66,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF7B5CF3),
                      radius: 42,
                      child: Center(
                          child: Text(
                        _start.toString(),
                        style:
                            const TextStyle(fontSize: 47, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
