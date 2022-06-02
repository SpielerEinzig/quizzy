import 'package:cloud_firestore/cloud_firestore.dart';

class SingleMatchingService {
  final _fireStore = FirebaseFirestore.instance;

  createRoom(
      {required DateTime timeCreated,
      required String userName,
      required String userId,
      required}) async {
    final gameRoomDocRef = await _fireStore.collection("singleMatch").add({
      "creatorUid": userId,
      "hasStarted": false,
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

  joinRoom({required String userName, required String roomDocId}) async {
    await _fireStore.collection("singleMatch").doc(roomDocId).update({
      "secondPlayer": userName,
      "secondScore": 0,
      "hasStarted": true,
    });
  }
}
