import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentMatchingService {
  final _fireStore = FirebaseFirestore.instance;

  createTournament(
      {required String creatorUid,
      required String name,
      required bool isBot}) async {
    //create tournament main collection
    final gameDocRef = await _fireStore.collection("tournamentMatch").add({
      "hasStarted": false,
      "hasEnded": false,
      "round": 1,
      "usersCount": 1,
    });
    //create user sub-collection inside tournament
    await _fireStore
        .collection("tournamentMatch")
        .doc(gameDocRef.id)
        .collection("match")
        .doc(creatorUid)
        .set({
      "score": 0,
      "uid": creatorUid,
      "name": name,
      "isBot": isBot,
      "inGame": false,
      "eliminated": false,
      "eliminated2": false,
      "eliminated3": false,
    });

    return gameDocRef.id;
  }

  joinTournament({
    required String name,
    required String gameDocID,
    required String uid,
    required bool isBot,
  }) async {
    try {
      //add to users count
      await _fireStore.collection("tournamentMatch").doc(gameDocID).update({
        "userCount": FieldValue.increment(1),
      });

      await _fireStore
          .collection("tournamentMatch")
          .doc(gameDocID)
          .collection("match")
          .doc(uid)
          .set({
        "score": 0,
        "uid": uid,
        "name": name,
        "isBot": isBot,
        "inGame": false,
        "eliminated": false,
        "eliminated2": false,
        "eliminated3": false,
      });

      final gameRef =
          await _fireStore.collection("tournamentMatch").doc(gameDocID).get();
      final gameData = gameRef.data()!;

      final userCount = gameData["userCount"];

      if (userCount == 8) {
        await _fireStore
            .collection("tournamentMatch")
            .doc(gameDocID)
            .update({"hasStarted": true});
      }
    } catch (e) {
      print("Error joining tournament: $e");
    }
  }

  eliminateLosersRound1({
    required List playerList,
    required String gameId,
  }) async {
    //if losers have not been eliminated, eliminate them
    for (var player in playerList) {
      int index = playerList.indexOf(player);
      if (index > 3) {
        await _fireStore
            .collection("tournamentMatch")
            .doc(gameId)
            .collection("match")
            .doc(player.id)
            .update({
          "eliminated": true,
        });
      }
    }
  }

  eliminateLosersRound2({
    required List playerList,
    required String gameId,
  }) async {
    //if losers have not been eliminated, eliminate them
    for (var player in playerList) {
      int index = playerList.indexOf(player);
      if (index > 1) {
        await _fireStore
            .collection("tournamentMatch")
            .doc(gameId)
            .collection("match")
            .doc(player.id)
            .update({
          "eliminated2": true,
        });
      }
    }
  }

  eliminateLosersRound3({
    required List playerList,
    required String gameId,
  }) async {
    //if losers have not been eliminated, eliminate them
    for (var player in playerList) {
      int index = playerList.indexOf(player);
      if (index > 0) {
        await _fireStore
            .collection("tournamentMatch")
            .doc(gameId)
            .collection("match")
            .doc(player.id)
            .update({
          "eliminated3": true,
        });
      }
    }
  }

  addWinnerPoint({required String uid, required String gameId}) async {
    try {
      await _fireStore.collection("users").doc(uid).update({
        "point": FieldValue.increment(10),
      });
    } catch (e) {
      print("Error adding winners point in tournament service $e");
    }

    try {
      await _fireStore.collection("tournamentMatch").doc(gameId).update({
        "hasEnded": true,
      });
    } catch (e) {
      print("Error declaring game ended");
    }
  }
}
