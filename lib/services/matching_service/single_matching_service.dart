import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy/constants.dart';

import '../../models/single_match_player_results.dart';

class SingleMatchingService {
  final _fireStore = FirebaseFirestore.instance;

  createRoom({
    required DateTime timeCreated,
    required String userName,
    required String userId,
  }) async {
    final gameRoomDocRef = await _fireStore.collection("singleMatch").add({
      "firstUid": userId,
      "secondUid": "",
      "hasStarted": false,
      "gameEnded": false,
      "timeCreated": timeCreated,
      "firstPlayerDone": false,
      "firstPlayer": userName,
      "firstScore": 0,
      "secondPlayerDone": false,
      "secondPlayer": "",
      "secondScore": 0,
    });

    return gameRoomDocRef.id;
  }

  joinRoom(
      {required String userName,
      required String roomDocId,
      required String userId}) async {
    await _fireStore.collection("singleMatch").doc(roomDocId).update({
      "secondPlayer": userName,
      "secondUid": userId,
      "secondScore": 0,
      "hasStarted": true,
    });
  }

  addBot({required String roomDocId, required int questionsLength}) async {
    int botNameIndex = Random().nextInt(botNames.length);
    int botScore = Random().nextInt(questionsLength);
    String botName = botNames[botNameIndex];

    await _fireStore.collection("singleMatch").doc(roomDocId).update({
      "secondPlayer": botName,
      "secondUid": "",
      "secondScore": botScore,
      "hasStarted": true,
      "secondPlayerDone": true,
    });
  }

  SingleMatchPlayerResultDetails declareWinner(
      {required SingleMatchPlayerResultDetails firstPlayer,
      required SingleMatchPlayerResultDetails secondPlayer}) {
    int firstScore = firstPlayer.score;
    int secondScore = secondPlayer.score;

    if (firstScore > secondScore) {
      return firstPlayer;
    } else if (secondScore > firstScore) {
      return secondPlayer;
    } else {
      return SingleMatchPlayerResultDetails(
        userId: "",
        playerDone: true,
        playerName: "Draw",
        score: firstScore,
      );
    }
  }

  addWinnerPoint({required String winnerUid, required String gameId}) async {
    final gameRef =
        await _fireStore.collection("singleMatch").doc(gameId).get();
    final gameData = gameRef.data()!;

    var gameEnded = gameData["gameEnded"];

    //if(gameEnded == false){
    try {
      await _fireStore.collection("users").doc(winnerUid).update({
        "point": FieldValue.increment(5),
      });
    } catch (e) {
      print("Error adding winner's points: $e");
    }

    await _setGameStatusComplete(gameId: gameId);
    //}
  }

  _setGameStatusComplete({required String gameId}) async {
    try {
      await _fireStore.collection("singleMatch").doc(gameId).update({
        "gameEnded": true,
      });
    } catch (e) {
      print("Error setting game status as complete: $e");
    }
  }

  uploadUserResults(
      {required bool createdGame,
      required int score,
      required String roomName}) async {
    if (createdGame == true) {
      try {
        await _fireStore.collection("singleMatch").doc(roomName).update({
          //"firstPlayerDone": true,
          "firstScore": score,
        });
      } catch (e) {
        print("Error with uploading results when user created game: $e");
      }
    } else {
      try {
        await _fireStore.collection("singleMatch").doc(roomName).update({
          //"secondPlayerDone": true,
          "secondScore": score,
        });
      } catch (e) {
        print("Error with uploading results when user didn't create game: $e");
      }
    }
  }
}
