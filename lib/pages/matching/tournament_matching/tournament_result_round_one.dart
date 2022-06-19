import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/result_page/result_page_components.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/pages/matching/tournament_matching/tournament_questions_second_round.dart';
import 'package:quizzy/services/database.dart';
import 'package:quizzy/services/matching_service/tournament_matching_service.dart';

import '../../../components/tournament_matching/tournament_matching_result_first_round.dart';
import '../../../components/waiting_screen_widget.dart';

class TournamentResultRoundOne extends StatefulWidget {
  final String gameId;
  final int questionId;
  const TournamentResultRoundOne(
      {Key? key, required this.gameId, required this.questionId})
      : super(key: key);

  @override
  State<TournamentResultRoundOne> createState() =>
      _TournamentResultRoundOneState();
}

class _TournamentResultRoundOneState extends State<TournamentResultRoundOne> {
  final _fireStore = FirebaseFirestore.instance;
  final _tournamentMatchingService = TournamentMatchingService();
  bool removedLosers1 = false;
  int time = 6;
  late Timer _round2;
  late StreamSubscription playersStream;

  List snapshotDocs = [];
  List userIds = [];

  _startSecondRoundTimer() {
    Duration timerDuration = const Duration(seconds: 1);
    _round2 = Timer.periodic(timerDuration, (timer) {
      if (time <= 0) {
        userIds.indexOf(userPointRankingModel.uid) < 4
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TournamentQuestionsSecondRound(
                      gameId: widget.gameId, questionId: widget.questionId),
                ),
              )
            : Navigator.pushReplacementNamed(context, HomeScreen.id);
      } else {
        setState(() {
          time--;
        });
      }
    });
  }

  listenRoundOneDetails() async {
    playersStream = _fireStore
        .collection("tournamentMatch")
        .doc(widget.gameId)
        .collection("match")
        .where('inGame', isEqualTo: false)
        .orderBy("score", descending: true)
        .snapshots()
        .listen((snapshot) {
      snapshotDocs = snapshot.docs;

      userIds = snapshotDocs.map((item) => item.id).toList();

      if (snapshot.docChanges.isNotEmpty) {
        setState(() {});
      }

      if (snapshotDocs.length > 7 && removedLosers1 == false) {
        _tournamentMatchingService.eliminateLosersRound1(
          playerList: snapshotDocs,
          gameId: widget.gameId,
        );
        _startSecondRoundTimer();

        removedLosers1 = true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenRoundOneDetails();
  }

  @override
  void dispose() {
    _round2.cancel();
    playersStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: snapshotDocs.length < 8
          ? waitingScreenWidget(
              bottomText: "Waiting for other players",
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/tournament_result/tournamentBackground.png",
                ),
              )),
              child: Stack(
                children: [
                  greatJobThumbsUp(x: 0, y: -0.85),
                  bottomAvatarGlow(x: 0, y: 0.99, centerText: time.toString()),
                  //Player score ribbon combo
                  coOrdinatedWidget(
                    x: 0,
                    y: -0.45,
                    widget: Text(
                      loremText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  coOrdinatedWidget(
                    x: 0,
                    y: 0.65,
                    widget: const Text(
                      "1st ROUND",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff6C7FF3),
                      ),
                    ),
                  ),
                  userScoreRibbon(
                      x: -0.3,
                      y: 0,
                      height: screenHeight * 0.25,
                      width: screenWidth * 0.37,
                      position: 1,
                      name: snapshotDocs[0]["name"],
                      score: snapshotDocs[0]["score"].toString()),
                  userScoreRibbon(
                      x: 0.9,
                      y: -0.1,
                      height: screenHeight * 0.17,
                      width: screenWidth * 0.24,
                      position: 2,
                      name: snapshotDocs[1]["name"],
                      score: snapshotDocs[1]["score"].toString()),
                  userScoreRibbon(
                      x: -0.9,
                      y: 0.3,
                      height: screenHeight * 0.14,
                      width: screenWidth * 0.19,
                      position: 3,
                      name: snapshotDocs[2]["name"],
                      score: snapshotDocs[2]["score"].toString()),
                  userScoreRibbon(
                      x: 0.6,
                      y: 0.4,
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.19,
                      position: 4,
                      name: snapshotDocs[3]["name"],
                      score: snapshotDocs[3]["score"].toString()),
                ],
              ),
            ),
    );
  }
}
