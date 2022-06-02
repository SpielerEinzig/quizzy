import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/models/user_model.dart';

import '../models/user_point_ranking_model.dart';
import '../pages/home_screen/home_screen.dart';
import 'api_services.dart';

int _point = 10;
int _localRank = 0;
int _worldRank = 0;
String _name = "User";
String _location = "location";
String _uid = "";
bool _connecting = false;
bool _inGame = false;

//created two lists to be able to sort and order users.
//forgive me but this was the fastest way i could
List<UserModel> _unOrderedWorldUsers = [];
List<UserModel> worldUsers = [];

//local Rank user list (ordered and unordered)
List<UserModel> _unOrderedLocalUsers = [];
List<UserModel> localUsers = [];

UserPointRankingModel userPointRankingModel = UserPointRankingModel(
  name: _name,
  point: _point,
  localRank: _localRank,
  worldRank: _worldRank,
  location: _location,
  connecting: _connecting,
  inGame: _inGame,
  uid: _uid,
);

class DataBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  registerFirestoreUser(
      {required User? user, required context, required String location}) async {
    if (user!.uid != null) {
      //String email = user.email!;
      print("Registering user");

      _firestore.collection("users").doc(user.uid).get().then((doc) {
        if (doc.exists) {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        } else {
          //create user model if user does not have an account
          _firestore.collection("users").doc(user.uid).set({
            "name": user.displayName,
            "email": user.email,
            "point": 0,
            "location": location,
            "connecting": false,
            "inGame": false,
          });

          Navigator.of(context).pushReplacementNamed(HomeScreen.id);
        }
      });
    }
  }

  statusCardServices({required String userId}) async {
    await fetchTotalPoint(userId: userId);
    await getUserWorldRank();
  }

  fetchTotalPoint({required String userId}) async {
    var userDocument = await _firestore.collection("users").doc(userId).get();

    int points = userDocument["point"];
    String name = userDocument["name"];
    String location = userDocument["location"];
    bool connecting = userDocument["connecting"];
    bool inGame = userDocument["inGame"];

    userPointRankingModel.point = points;
    userPointRankingModel.name = name;
    userPointRankingModel.location = location;
    userPointRankingModel.inGame = inGame;
    userPointRankingModel.connecting = connecting;
    userPointRankingModel.uid = userId;

    return userPointRankingModel;
  }

  Future<double> fetchTotalDollar() async {
    int userPoint = userPointRankingModel.point;

    int pointConversionRate = await APIService().getPriceConversion();

    double totalUserDollar = userPoint / pointConversionRate;

    return totalUserDollar;
  }

  getUserWorldRank() async {
    var getAllDocuments = await _firestore.collection("users").get();

    var allUserDocuments = getAllDocuments.docs;

    for (var userDoc in allUserDocuments) {
      UserModel individualUser = UserModel(
        name: userDoc["name"],
        point: userDoc["point"],
        location: userDoc["location"],
        inGame: userDoc["inGame"],
        connecting: userDoc["connecting"],
        uid: userDoc.id,
      );

      if (_unOrderedWorldUsers.contains(individualUser)) {
      } else {
        _unOrderedWorldUsers.add(individualUser);
      }

      if (userPointRankingModel.location == individualUser.location) {
        if (_unOrderedLocalUsers.contains(individualUser)) {
        } else {
          _unOrderedLocalUsers.add(individualUser);
        }
      }
    }

    _unOrderedWorldUsers.sort((a, b) => a.point.compareTo(b.point));
    _unOrderedLocalUsers.sort((a, b) => a.point.compareTo(b.point));

    worldUsers = _unOrderedWorldUsers.reversed.toList();
    localUsers = _unOrderedLocalUsers.reversed.toList();

    int indexWorldUsers = worldUsers.indexWhere(
          (user) =>
              user.name == userPointRankingModel.name &&
              user.location == userPointRankingModel.location,
        ) +
        1;

    int indexLocalUsers = localUsers.indexWhere(
          (user) =>
              user.name == userPointRankingModel.name &&
              user.location == userPointRankingModel.location,
        ) +
        1;

    userPointRankingModel.worldRank = indexWorldUsers;
    userPointRankingModel.localRank = indexLocalUsers;
  }
}
