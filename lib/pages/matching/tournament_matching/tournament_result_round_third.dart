import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/result_page/result_page_components.dart';
import '../../../components/waiting_screen_widget.dart';
import '../../../constants.dart';
import '../../../services/api_services.dart';
import '../../../services/matching_service/tournament_matching_service.dart';
import '../../home_screen/home_screen.dart';

class TournamentResultRoundThree extends StatefulWidget {
  final int questionId;
  final String gameId;
  const TournamentResultRoundThree(
      {Key? key, required this.gameId, required this.questionId})
      : super(key: key);

  @override
  State<TournamentResultRoundThree> createState() =>
      _TournamentResultRoundThreeState();
}

class _TournamentResultRoundThreeState
    extends State<TournamentResultRoundThree> {
  final _fireStore = FirebaseFirestore.instance;
  final apiService = APIService();
  final _tournamentMatchingService = TournamentMatchingService();
  bool removedLosers1 = false;
  int time = 6;
  late Timer _round3;
  late StreamSubscription playersStream;

  List snapshotDocs = [];
  List userIds = [];

  _startSecondRoundTimer() {
    Duration timerDuration = const Duration(seconds: 1);
    _round3 = Timer.periodic(timerDuration, (timer) {
      if (time <= 0) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
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
        .where("eliminated", isEqualTo: false)
        .where("eliminated2", isEqualTo: false)
        .orderBy("score", descending: true)
        .snapshots()
        .listen((snapshot) {
      snapshotDocs = snapshot.docs;
      userIds = snapshotDocs.map((item) => item.id).toList();

      if (snapshot.docChanges.isNotEmpty) {
        setState(() {});
      }

      if (snapshotDocs.length > 1 && removedLosers1 == false) {
        _tournamentMatchingService.eliminateLosersRound3(
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
    _round3.cancel();
    playersStream.cancel();
    _tournamentMatchingService.addWinnerPoint(
        uid: snapshotDocs[0]["uid"], gameId: widget.gameId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: snapshotDocs.length < 2
            ? waitingScreenWidget(
                bottomText: "Waiting for other players",
              )
            : Stack(
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
                                    "Name: ${snapshotDocs[0]["name"]} "
                                    "Score: ${snapshotDocs[0]["score"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Name: ${snapshotDocs[1]["name"]} "
                                    "Score: ${snapshotDocs[1]["score"]}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "\nWinner: ${snapshotDocs[0]["name"]}\n"
                                    "WinnerScore: ${snapshotDocs[0]["score"]}",
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
                      score: snapshotDocs[0]["score"],
                      imagePath: "assets/images/results_page/ribbon_badge.png"),
                  shareCard(context: context, onPressed: () async {}),
                  Container(
                    alignment: const Alignment(0, -0.72),
                    child: Text(
                      snapshotDocs[0]["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ));
  }
}
