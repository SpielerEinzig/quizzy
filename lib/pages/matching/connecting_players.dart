import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/single_match_page_stack.dart';
import 'package:quizzy/pages/matching/countdown.dart';
import 'package:quizzy/services/matching_service/single_matching_service.dart';

import '../../services/database.dart';

class ConnectPlayers extends StatefulWidget {
  static const String id = "connectPlayers";

  const ConnectPlayers({Key? key}) : super(key: key);

  @override
  _ConnectPlayersState createState() => _ConnectPlayersState();
}

class _ConnectPlayersState extends State<ConnectPlayers> {
  final _fireStore = FirebaseFirestore.instance;
  final singleMatchService = SingleMatchingService();

  String name = userPointRankingModel.name;
  String secondUser = "Searching";
  String roomId = "";
  bool createdGame = false;

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
          userName: userPointRankingModel.name,
          roomDocId: gameDoc.id,
        );

        roomId = gameDoc.id;
        secondUser = gameDoc["firstPlayer"];
      } else {
        roomId = await singleMatchService.createRoom(
            timeCreated: DateTime.now(),
            userName: userPointRankingModel.name,
            userId: userPointRankingModel.uid);
        createdGame = true;
      }
    });
  }

  startGame({required String roomID}) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CountDownPage(roomName: roomID);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getGamesAvailable(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
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
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final snapshotData = snapshot.data!;

                    bool matchStarted = snapshotData["hasStarted"];

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
