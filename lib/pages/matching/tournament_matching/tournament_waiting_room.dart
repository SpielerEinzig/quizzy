import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/models/tournament_user.dart';
import 'package:quizzy/pages/matching/tournament_matching/tournament_questions_page.dart';

import '../../../components/tournament_pair_card.dart';

class TournamentWaitingRoom extends StatefulWidget {
  final String gameId;
  final int questionId;
  const TournamentWaitingRoom(
      {Key? key, required this.gameId, required this.questionId})
      : super(key: key);

  @override
  State<TournamentWaitingRoom> createState() => _TournamentWaitingRoomState();
}

class _TournamentWaitingRoomState extends State<TournamentWaitingRoom> {
  final _fireStore = FirebaseFirestore.instance;
  bool hasStarted = false;
  int timerCount = 5;
  late Timer _timer;
  late StreamSubscription gameDetails;
  late StreamSubscription gameStatus;
  List<TournamentMatchPair> players = [];
  List<TournamentMatchUser> playerList = [];

  startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) {
      if (timerCount == 0) {
        timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  // TournamentResultRoundOne(gameId: widget.gameId)
                  TournamentQuestions(
                gameId: widget.gameId,
                questionId: widget.questionId,
              ),
            ));
      } else {
        setState(() {
          timerCount--;
        });
      }
    });
  }

  listenGameDetails() {
    gameDetails = _fireStore
        .collection("tournamentMatch")
        .doc(widget.gameId)
        .collection("match")
        .orderBy("name")
        .snapshots()
        .listen((snapshot) {
      final docRef = snapshot.docs;

      playerList = docRef.map((item) {
        return TournamentMatchUser(
          uid: item["uid"],
          name: item["name"],
          score: item["score"],
          inGame: item["inGame"],
          isBot: item["isBot"],
        );
      }).toList();

      for (var item in playerList) {
        int index = playerList.indexOf(item);
        int addedIndex = index + 1;

        if (index != 0 && addedIndex % 2 == 0) {
          TournamentMatchPair value = TournamentMatchPair(
            first: item,
            second: playerList[index - 1],
          );
          //check if list contains player pair
          if (players.contains(value)) {
            players[players.indexOf(value)] = value;
          } else {
            players.add(value);
          }
          //done checking
        }
      }

      if (snapshot.docChanges.isNotEmpty) {
        setState(() {});
      }

      setState(() {});
    });
  }

  listenGameStatus() {
    gameStatus = _fireStore
        .collection("tournamentMatch")
        .doc(widget.gameId)
        .snapshots()
        .listen((snapshot) {
      final snapshotData = snapshot.data()!;

      hasStarted = snapshotData["hasStarted"];

      if (hasStarted == true) {
        setState(() {
          startTimer();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenGameStatus();
    listenGameDetails();
  }

  @override
  void dispose() {
    _timer.cancel();
    gameDetails.cancel();
    gameStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
                        timerCount.toString(),
                        style: const TextStyle(
                          fontSize: 47,
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("Tapped");
                      });
                    },
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
          Expanded(
            // child: GridView.builder(
            //   itemCount: players.length,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 19,
            //     crossAxisSpacing: 15,
            //   ),
            //   padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 15),
            //   itemBuilder: (context, index) {
            //     return tournamentPairCard(
            //       firstPlayer: players[index].first.name,
            //       secondPlayer: players[index].second.name,
            //       width: screenWidth * 0.44,
            //       height: screenHeight * 0.23,
            //     );
            //   },
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 19,
                  crossAxisSpacing: 15,
                ),
                children: [
                  tournamentPairCard(
                    firstPlayer:
                        playerList.isEmpty ? "waiting" : playerList[0].name,
                    secondPlayer:
                        playerList.length < 2 ? "waiting" : playerList[1].name,
                    width: screenWidth * 0.44,
                    height: screenHeight * 0.23,
                  ),
                  tournamentPairCard(
                    firstPlayer:
                        playerList.length < 3 ? "waiting" : playerList[2].name,
                    secondPlayer:
                        playerList.length < 4 ? "waiting" : playerList[3].name,
                    width: screenWidth * 0.44,
                    height: screenHeight * 0.23,
                  ),
                  tournamentPairCard(
                    firstPlayer:
                        playerList.length < 5 ? "waiting" : playerList[4].name,
                    secondPlayer:
                        playerList.length < 6 ? "waiting" : playerList[5].name,
                    width: screenWidth * 0.44,
                    height: screenHeight * 0.23,
                  ),
                  tournamentPairCard(
                    firstPlayer:
                        playerList.length < 7 ? "waiting" : playerList[6].name,
                    secondPlayer:
                        playerList.length < 8 ? "waiting" : playerList[7].name,
                    width: screenWidth * 0.44,
                    height: screenHeight * 0.23,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
