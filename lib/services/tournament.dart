import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/models/questions_model.dart';
import 'package:quizzy/pages/matching/tournament/connecting_tournament.dart';

import 'package:http/http.dart' as http;

List<QuestionsModel> tournamentQuestionsList = [];

class TournamentService {
  //TODO: Don't modify, other code breaking pages and services depend on this int
  int maxUsersInRoom = 4;

  final _fireStore = FirebaseFirestore.instance;

  getTournamentQuestions({required int id, required bool finalRound}) async {
    tournamentQuestionsList.clear();

    int questions = 10;
    finalRound ? questions = 15 : questions = 10;

    print("initializing uri");

    http.Response response = await http.get(Uri.parse(
        "http://210.56.9.60/Quizzly/api/QuizContent?categoryId=$id&difficultId=1&isActive=1&totalQuestions=$questions"));

    if (response.statusCode == 200) {
      print("fetching complete, code: ${response.statusCode}");

      print(response.body);

      var jsonData = await jsonDecode(response.body);

      for (var item in jsonData) {
        List<String> preparedList = [
          item["option1"],
          item["option2"],
          item["option3"],
          item["option4"],
        ];

        preparedList.shuffle();

        var value = QuestionsModel(
          question: item["MainQuestion"],
          answer: item["Answer"],
          questionAnswered: false,
          options: preparedList,
        );

        tournamentQuestionsList.add(value);
      }
    } else {
      print("Responnse code is ${response.statusCode}");
    }
  }

  createTournament({
    required String userId,
    required String userName,
  }) async {
    //get the user gameRoom document in fireStore
    final userGameRoom =
        await _fireStore.collection("tournament").doc(userId).get();

    //check if gameRoom exists and delete all player documents
    if (userGameRoom.exists) {
      await _fireStore
          .collection("tournament")
          .doc(userId)
          .collection(userId)
          .get()
          .then((docSnapshot) {
        for (var doc in docSnapshot.docs) {
          doc.reference.delete();
        }
      });
    }

    //set game hasStarted to false
    await _fireStore.collection("tournament").doc(userId).set({
      "hasStarted": false,
    });

    //create player doc in room
    await _fireStore
        .collection("tournament")
        .doc(userId)
        .collection(userId)
        .doc(userId)
        .set({
      "roomIndex": 1,
      "score": 0,
      "name": userName,
      "userId": userId,
      "isBot": false,
    });
  }

  joinGame({
    required context,
    required String userId,
    required String userName,
    required bool isBot,
    required String gameId,
  }) async {
    int usersInRoom = 0;

    //create user model in game room
    await _fireStore
        .collection("tournament")
        .doc(gameId)
        .collection(gameId)
        .doc(userId)
        .set({
      "name": userName,
      "userId": userId,
      "score": 0,
      "isBot": isBot,
      "roomIndex": usersInRoom + 1,
    });

    //get the game room document check amount of users
    final gameRoom = await _fireStore
        .collection("tournament")
        .doc(gameId)
        .collection(gameId)
        .get();

    //get amount of users in gameRoom based on doc length
    var playerDocs = gameRoom.docs;

    for (var player in playerDocs) {
      usersInRoom += 1;
    }

    //check if users in game room is greater or equal to 8
    if (usersInRoom >= maxUsersInRoom) {
      await _fireStore.collection("tournament").doc(gameId).update({
        "hasStarted": true,
      });
    } else {
      print("The room is full");
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConnectingTournament(
                  gameRoom: gameId,
                )));
  }
}

class TournamentUserModel {
  String userName;
  String userId;
  int score;
  bool isBot;
  int roomIndex;

  TournamentUserModel({
    required this.userName,
    required this.userId,
    required this.isBot,
    required this.score,
    required this.roomIndex,
  });
}
