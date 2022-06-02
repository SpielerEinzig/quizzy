import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzy/services/database.dart';

class MatchingFriendService {
  final _fireStore = FirebaseFirestore.instance;

  sendInvite({
    required String senderName,
    required String senderUid,
    required bool valid,
    required DateTime timeSent,
    required String friendUid,
    required bool friendAccepted,
  }) async {
    try {
      await _fireStore
          .collection("notifications")
          .doc(friendUid)
          .collection(friendUid)
          .doc(senderUid)
          .set({
        "sender": senderName,
        "senderUid": senderUid,
        "valid": valid,
        "timeSent": timeSent,
        "friendAccepted": friendAccepted,
      });
    } catch (e) {
      print(e);
    }
  }

  cancelInvite({required String friendUid, required String senderName}) async {
    try {
      await _fireStore
          .collection("notifications")
          .doc(friendUid)
          .collection(friendUid)
          .doc(userPointRankingModel.uid)
          .update({
        "valid": false,
      });
    } catch (e) {
      print(e);
    }
  }

  createGameToPlayWithFriend({
    required String creatorUid,
    required String senderName,
  }) async {
    //create game room and set hasStarted to false
    try {
      await _fireStore.collection("games").doc(creatorUid).set({
        "hasStarted": false,
      });
    } catch (e) {
      print("Error in createGameToPlayWithFriend function: $e");
    }

    //create the creator's game document
    try {
      await _fireStore
          .collection("games")
          .doc(creatorUid)
          .collection(creatorUid)
          .doc(creatorUid)
          .set({
        "name": senderName,
        "score": 0,
        "isBot": false,
      });
    } catch (e) {
      print("Error in createGameToPlayWithFriend function: $e");
    }
  }

  joinFriendsGame({
    required String creatorUid,
    required String userUid,
    required String userName,
  }) async {
    //set game accepted status to true
    // and valid to false in the user's notification
    try {
      await _fireStore
          .collection("notifications")
          .doc(userUid)
          .collection(userUid)
          .doc(creatorUid)
          .update({
        "valid": false,
        "friendAccepted": true,
      });
    } catch (e) {
      print(e);
    }
    //create a user document in game invited to
    try {
      await _fireStore
          .collection("games")
          .doc(creatorUid)
          .collection(creatorUid)
          .doc(userUid)
          .set({
        "name": userName,
        "score": 0,
        "isBot": false,
      });
    } catch (e) {
      print(e);
    }

    //set game hasStarted status to true
    try {
      await _fireStore.collection("games").doc(creatorUid).update({
        "hasStarted": true,
      });
    } catch (e) {
      print(e);
    }
  }
}
