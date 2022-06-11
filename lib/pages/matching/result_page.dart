import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/home_screen/home_screen.dart';
import 'package:quizzy/services/database.dart';

import '../../components/result_page/result_page_components.dart';
import '../../constants.dart';

class ResultsPage extends StatefulWidget {
  static const id = "resultsPage";

  int score;
  String roomName;
  int timeRemaining;

  ResultsPage({
    Key? key,
    required this.score,
    required this.roomName,
    required this.timeRemaining,
  }) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final _firestore = FirebaseFirestore.instance;

  String name = userPointRankingModel.name;

  performCleanUp() async {
    //delete bots in game
    final playersInRoom = await _firestore
        .collection("games")
        .doc(widget.roomName)
        .collection(widget.roomName)
        .get();

    var allPlayerDocs = playersInRoom.docs;

    for (var playerDoc in allPlayerDocs) {
      bool isBot = playerDoc["isBot"];

      if (isBot == true) {
        await _firestore
            .collection("games")
            .doc(widget.roomName)
            .collection(widget.roomName)
            .doc(playerDoc.id)
            .delete();
        print("deleted bot: ${playerDoc.id}");
      }
    }

    //delete user game if created
    await _firestore
        .collection("games")
        .doc(widget.roomName)
        .collection(widget.roomName)
        .doc(userPointRankingModel.uid)
        .delete();
    print("userPointRankingName is: $name");
    //add points to userPoints
    final userDoc = await _firestore
        .collection("users")
        .doc(userPointRankingModel.uid)
        .get();

    int userPoint = userDoc["point"];

    int updatedPoint = userPoint + widget.score;

    //update user point
    await _firestore
        .collection("users")
        .doc(userPointRankingModel.uid)
        .update({"point": updatedPoint});

    //go back to home after user is done
    await Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //performCleanUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      image: const DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/images/intersect.png"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "CONGRATULATIONS",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            loremText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/images/results_page/coin.png",
                    height: 70,
                    width: 70,
                  ),
                ],
              ),
            ),
          ),
          badgeScore(
              score: widget.score,
              imagePath: "assets/images/results_page/ribbon_badge.png"),
          shareCard(
              context: context,
              onPressed: () async {
                print("share button pressed");
                print("User score: ${widget.score}\n"
                    "Time remaining: ${widget.timeRemaining}\n"
                    "Room Id: ${widget.roomName}\n");
              }),
        ],
      ),
    );
  }
}
