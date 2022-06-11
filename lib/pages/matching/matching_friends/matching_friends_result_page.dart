import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/services/matching_service/friend_matching_service.dart';

import '../../../components/countdown_screen_widget.dart';
import '../../../components/result_page/result_page_components.dart';
import '../../../constants.dart';
import '../../../models/single_match_player_results.dart';

String text = "Matching friends results page";

class MatchingFriendsResultsPage extends StatefulWidget {
  final int score;
  final String roomName;
  final int timeRemaining;
  final bool createdGame;

  const MatchingFriendsResultsPage({
    Key? key,
    required this.roomName,
    required this.timeRemaining,
    required this.score,
    required this.createdGame,
  }) : super(key: key);

  @override
  State<MatchingFriendsResultsPage> createState() =>
      _MatchingFriendsResultsPageState();
}

class _MatchingFriendsResultsPageState
    extends State<MatchingFriendsResultsPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _friendMatchingService = FriendMatchingService();
  late StreamSubscription gameDetailListener;

  late SingleMatchPlayerResultDetails playerOne;
  late SingleMatchPlayerResultDetails playerTwo;
  SingleMatchPlayerResultDetails? winner;

  gameComplete() async {
    await Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    });
  }

  getGameDetails() async {
    await _friendMatchingService.uploadUserResults(
        createdGame: widget.createdGame,
        score: widget.score,
        gameId: widget.roomName);

    gameDetailListener = _fireStore
        .collection("friendlyMatches")
        .doc(widget.roomName)
        .snapshots()
        .listen((gameData) {
      var creatorDone = gameData["creatorDone"];
      var inviteDone = gameData["inviteDone"];

      playerOne = SingleMatchPlayerResultDetails(
        userId: gameData["creatorUid"],
        playerName: gameData["creatorName"],
        score: gameData["creatorScore"],
        playerDone: gameData["creatorDone"],
      );

      playerTwo = SingleMatchPlayerResultDetails(
        userId: gameData["inviteUid"],
        playerName: gameData["inviteName"],
        score: gameData["inviteScore"],
        playerDone: gameData["inviteDone"],
      );

      if (creatorDone && inviteDone) {
        winner = _friendMatchingService.declareWinner(
            firstPlayer: playerOne, secondPlayer: playerTwo);

        setState(() {});

        gameComplete();
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
    _friendMatchingService.addWinnerPoint(
        winnerUid: winner!.userId, gameId: widget.roomName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: winner != null
          ? Stack(
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
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
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
                              image: AssetImage("assets/images/intersect.png"),
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
                                  "Name: ${playerTwo.playerName}"
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
            ),
    );
  }
}
