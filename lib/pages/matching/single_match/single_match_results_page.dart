import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';

import '../../../components/countdown_screen_widget.dart';
import '../../../components/result_page/result_page_components.dart';
import '../../../constants.dart';
import '../../../models/single_match_player_results.dart';
import '../../../services/matching_service/single_matching_service.dart';

class SingleMatchResultsPage extends StatefulWidget {
  final int score;
  final String roomName;
  final int timeRemaining;
  final bool createdGame;

  const SingleMatchResultsPage({
    Key? key,
    required this.roomName,
    required this.timeRemaining,
    required this.score,
    required this.createdGame,
  }) : super(key: key);

  @override
  State<SingleMatchResultsPage> createState() => _SingleMatchResultsPageState();
}

class _SingleMatchResultsPageState extends State<SingleMatchResultsPage> {
  final _fireStore = FirebaseFirestore.instance;
  final singleMatchingService = SingleMatchingService();
  late StreamSubscription gameDetailListener;
  late SingleMatchPlayerResultDetails playerOne;
  late SingleMatchPlayerResultDetails playerTwo;
  SingleMatchPlayerResultDetails? winner;

  void startSecondTimer() async {
    const delay = Duration(seconds: 6);
    await Future.delayed(delay, () {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    });
  }

  getGameDetails() async {
    await singleMatchingService.uploadUserResults(
      createdGame: widget.createdGame,
      roomName: widget.roomName,
      score: widget.score,
    );

    gameDetailListener = _fireStore
        .collection("singleMatch")
        .doc(widget.roomName)
        .snapshots()
        .listen((gameData) {
      var gameEnded = gameData["gameEnded"];

      var firstDone = gameData["firstPlayerDone"];
      var secondDone = gameData["secondPlayerDone"];

      playerOne = SingleMatchPlayerResultDetails(
        userId: gameData["firstUid"],
        playerName: gameData["firstPlayer"],
        score: gameData["firstScore"],
        playerDone: gameData["firstPlayerDone"],
      );

      playerTwo = SingleMatchPlayerResultDetails(
        userId: gameData["secondUid"],
        playerName: gameData["secondPlayer"],
        score: gameData["secondScore"],
        playerDone: gameData["secondPlayerDone"],
      );

      if (firstDone && secondDone) {
        winner = singleMatchingService.declareWinner(
          firstPlayer: playerOne,
          secondPlayer: playerTwo,
        );

        startSecondTimer();

        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGameDetails();
  }

  @override
  void dispose() {
    gameDetailListener.cancel();
    singleMatchingService.addWinnerPoint(
        winnerUid: winner!.userId, gameId: widget.roomName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: winner != null
            ? //firstDone && secondDone?
            Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 50,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(kDefaultBorderRadius),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 50,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kDefaultBorderRadius),
                              image: const DecorationImage(
                                fit: BoxFit.fitWidth,
                                image:
                                    AssetImage("assets/images/intersect.png"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 20),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "CONGRATULATIONS",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Name: ${playerOne.playerName} "
                                    "Score: ${playerOne.score}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Name: ${playerTwo.playerName} "
                                    "Score: ${playerTwo.score}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "\nWinner: ${winner!.playerName}\n"
                                    "WinnerScore: ${winner!.score}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/images/results_page/coin.png",
                            height: 70,
                            width: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                  badgeScore(
                      score: winner!.score,
                      imagePath: "assets/images/results_page/ribbon_badge.png"),
                  shareCard(context: context, onPressed: () async {}),
                  Container(
                    alignment: const Alignment(0, -0.72),
                    child: Text(
                      winner!.playerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : countdownScreenWidget(
                countdownInt: 0,
                bottomText: "Waiting for other player",
              ));
  }
}
