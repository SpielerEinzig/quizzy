import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/single_match/single_match_countdown.dart';
import 'package:quizzy/services/api_services.dart';

import '../../../components/single_match_page_stack.dart';
import '../../../services/database.dart';
import '../../../services/matching_service/single_matching_service.dart';

class SingleMatchConnectingPlayers extends StatefulWidget {
  const SingleMatchConnectingPlayers({Key? key}) : super(key: key);

  @override
  State<SingleMatchConnectingPlayers> createState() =>
      _SingleMatchConnectingPlayersState();
}

class _SingleMatchConnectingPlayersState
    extends State<SingleMatchConnectingPlayers> {
  final _fireStore = FirebaseFirestore.instance;
  final singleMatchService = SingleMatchingService();
  late Future getGames;
  //late Timer _timer;

  String name = userPointRankingModel.name;
  String secondUser = "Searching";
  String roomId = "";
  bool createdGame = false;
  bool matchStarted = false;

  startBotTimer() async {
    const botCountdown = Duration(seconds: 6);
    await Future.delayed(botCountdown);
    if (matchStarted == false) {
      await singleMatchService.addBot(
          roomDocId: roomId, questionsLength: questionList.length);
    }
  }

  getGamesAvailable() async {
    await _fireStore
        .collection("singleMatch")
        .where("hasStarted", isEqualTo: false)
        .limit(1)
        .get()
        .then((snapshot) async {
      final docsList = snapshot.docs;

      if (docsList.isNotEmpty) {
        final gameDoc = docsList[0];

        await singleMatchService.joinRoom(
          userId: userPointRankingModel.uid,
          userName: userPointRankingModel.name,
          roomDocId: gameDoc.id,
        );

        roomId = gameDoc.id;

        roomId = gameDoc.id;

        secondUser = gameDoc["firstPlayer"];
      } else {
        roomId = await singleMatchService.createRoom(
            timeCreated: DateTime.now(),
            userName: userPointRankingModel.name,
            userId: userPointRankingModel.uid);
        createdGame = true;
        startBotTimer();
      }
    });
  }

  startGame({required String roomID}) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return SingleMatchCountdown(
              gameId: roomID,
              createdGame: createdGame,
            );
          },
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGames = getGamesAvailable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getGames,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Something went wrong with future builder: ${snapshot.error.toString()}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (createdGame == true) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: _fireStore
                      .collection("singleMatch")
                      .doc(roomId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Something went wrong with stream'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final snapshotData = snapshot.data!;

                    matchStarted = snapshotData["hasStarted"];
                    secondUser = snapshotData["secondPlayer"];

                    if (matchStarted) {
                      startGame(roomID: roomId);
                    }

                    return singleMatchStack(
                        screenWidth: screenWidth,
                        name: name,
                        secondUser: secondUser);
                  });
            } else {
              startGame(roomID: roomId);
              return singleMatchStack(
                  screenWidth: screenWidth, name: name, secondUser: secondUser);
            }
          },
        ),
      ),
    );
  }
}
