import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/pages/matching/tournament/tournament_result_countdown.dart';
import 'package:quizzy/services/database.dart';

import '../../../components/tournament_name_score_column.dart';
import '../../../models/tournament_user.dart';
import '../questions_page.dart';

String congratulationText =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer dolor eget eget arcu varius. Mauris, proin ac rutrum";

final _fireStore = FirebaseFirestore.instance;

class TournamentResults extends StatefulWidget {
  final int score;
  final String roomName;

  const TournamentResults({
    Key? key,
    required this.roomName,
    required this.score,
  }) : super(key: key);

  @override
  _TournamentResultsState createState() => _TournamentResultsState();
}

class _TournamentResultsState extends State<TournamentResults> {
  late Timer _timer;
  int _start = 5;

  List<TournamentPlayerNameScore> tournamentPlayerScore = [];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => TournamentResultCountDown(
                        tournamentPlayerScore: tournamentPlayerScore,
                      )));
        } else {
          //setState(() {
          _start--;
          //});
        }
      },
    );
  }

  updateScore() async {
    await _fireStore
        .collection("tournament")
        .doc(widget.roomName)
        .collection(widget.roomName)
        .doc(userPointRankingModel.uid)
        .update({"score": widget.score});

    final userData = await _fireStore
        .collection("users")
        .doc(userPointRankingModel.uid)
        .get();

    int previousPoints = userData["point"];

    await _fireStore
        .collection("users")
        .doc(userPointRankingModel.uid)
        .update({"point": previousPoints + widget.score});

    startTimer();
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
    updateScore();
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
          child: StreamBuilder<QuerySnapshot>(
              stream: _fireStore
                  .collection("tournament")
                  .doc(widget.roomName)
                  .collection(widget.roomName)
                  .orderBy("score", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final playerDocsList = snapshot.data.docs;

                for (var player in playerDocsList) {
                  TournamentPlayerNameScore value = TournamentPlayerNameScore(
                    name: player["name"],
                    score: player["score"],
                  );

                  tournamentPlayerScore.add(value);
                }

                return Stack(
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
                        score: playerDocsList[0]["score"],
                        name: playerDocsList[0]["name"],
                        height: 80,
                        nameFontSize: 18,
                        scoreFontSize: 24,
                      ),
                    ),
                    Container(
                      alignment: const Alignment(0.9, 0.06),
                      child: positionedScoreNamePair(
                        score: playerDocsList[1]["score"],
                        name: playerDocsList[1]["name"],
                        height: 61,
                        nameFontSize: 15,
                        scoreFontSize: 18,
                      ),
                    ),
                    Container(
                      alignment: const Alignment(-0.87, 0.4),
                      child: positionedScoreNamePair(
                        score: playerDocsList[2]["score"],
                        name: playerDocsList[2]["name"],
                        height: 61,
                        nameFontSize: 15,
                        scoreFontSize: 16,
                      ),
                    ),
                    Container(
                      alignment: const Alignment(0.58, 0.45),
                      child: positionedScoreNamePair(
                        score: playerDocsList[3]["score"],
                        name: playerDocsList[3]["name"],
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
                            style: const TextStyle(
                                fontSize: 47, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
