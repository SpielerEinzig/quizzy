import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/single_match_page_stack.dart';
import 'package:quizzy/pages/matching/matching_friends/matching_friends_countdown.dart';
import 'package:quizzy/services/database.dart';

import '../../../services/matching_service/friend_matching_service.dart';

class ConnectingFriends extends StatefulWidget {
  final String inviteId;
  final String gameDocId;
  final bool isCreator;
  const ConnectingFriends({
    Key? key,
    required this.inviteId,
    required this.gameDocId,
    required this.isCreator,
  }) : super(key: key);

  @override
  State<ConnectingFriends> createState() => _ConnectingFriendsState();
}

class _ConnectingFriendsState extends State<ConnectingFriends> {
  final _fireStore = FirebaseFirestore.instance;
  final name = userPointRankingModel.name;
  final _friendMatchingService = FriendMatchingService();
  final secondUser = "Waiting";

  startGame() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MatchingFriendsCountdown(
          gameId: widget.gameDocId, createdGame: widget.isCreator);
    }));
  }

  @override
  void dispose() {
    if (widget.isCreator == true) {
      _friendMatchingService.cancelInvite(inviteId: widget.inviteId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Colors.greenAccent,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
            stream: _fireStore
                .collection("friendlyMatches")
                .doc(widget.gameDocId)
                .snapshots(),
            builder: (context, snapshot) {
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

              var gameStarted = snapshotData["hasStarted"];

              if (gameStarted == true) {
                startGame();
              }

              return singleMatchStack(
                screenWidth: screenWidth,
                name: name,
                secondUser: secondUser,
              );
            }),
      ),
    );
  }
}
