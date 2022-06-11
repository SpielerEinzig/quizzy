import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/single_match_player_results.dart';

class FriendMatchingService {
  final _fireStore = FirebaseFirestore.instance;

  sendInviteToFriend({
    required String inviteeName,
    required String inviteeUid,
    required String inviterName,
    required String inviterUid,
    required String gameDocId,
    required DateTime timeSent,
  }) async {
    try {
      final inviteDocRef = await _fireStore.collection("notifications").add({
        "inviterName": inviterName,
        "inviterUid": inviterUid,
        "inviteeUid": inviteeUid,
        "friendName": inviteeName,
        "timeSent": timeSent,
        "gameId": gameDocId,
        "inviteValid": true,
      });

      return inviteDocRef;
    } catch (e) {
      print("Error sending friend invite $e");
    }
  }

  cancelInvite({required String inviteId}) async {
    try {
      await _fireStore.collection("notifications").doc(inviteId).update({
        "inviteValid": false,
      });
    } catch (e) {
      print("Error cancelling invite: $e");
    }
  }

  createFriendlyGame(
      {required String userId,
      required DateTime timeCreated,
      required String userName,
      required String inviteUid,
      required String inviteName}) async {
    try {
      final gameDocRef = await _fireStore.collection("friendlyMatches").add({
        "creatorUid": userId,
        "inviteUid": inviteUid,
        "hasStarted": false,
        "gameEnded": false,
        "timeCreated": timeCreated,
        "creatorDone": false,
        "creatorName": userName,
        "creatorScore": 0,
        "inviteDone": false,
        "inviteName": inviteName,
        "inviteScore": 0,
      });

      return gameDocRef;
    } catch (e) {
      print("Error creating friendly game: $e");
    }
  }

  joinFriendlyGame(
      {required String gameId,
      required String userId,
      required String userName}) async {
    try {
      await _fireStore.collection("friendlyMatches").doc(gameId).update({
        "inviteUid": userId,
        "hasStarted": true,
        "inviteName": userName,
      });
    } catch (e) {
      print("Error joining friendly game: $e");
    }
  }

  uploadUserResults({
    required bool createdGame,
    required int score,
    required String gameId,
  }) async {
    if (createdGame == true) {
      try {
        await _fireStore.collection("friendlyMatches").doc(gameId).update({
          "creatorScore": score,
        });
      } catch (e) {
        print("Error uploading player result: $e");
      }
    } else {
      try {
        await _fireStore.collection("friendlyMatches").doc(gameId).update({
          "inviteScore": score,
        });
      } catch (e) {
        print("Error uploading player result: $e");
      }
    }
  }

  declareWinner(
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
    try {
      await _fireStore.collection("users").doc(winnerUid).update({
        "point": FieldValue.increment(5),
      });
    } catch (e) {
      print("Error adding winner's points: $e");
    }

    await _setGameStatusComplete(gameId: gameId);
  }

  _setGameStatusComplete({required String gameId}) async {
    try {
      await _fireStore.collection("friendlyMatches").doc(gameId).update({
        "gameEnded": true,
      });
    } catch (e) {
      print("Error setting game status as complete: $e");
    }
  }
}
