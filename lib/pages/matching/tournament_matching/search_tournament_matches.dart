import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/tournament_matching/tournament_waiting_room.dart';
import 'package:quizzy/services/database.dart';
import 'package:quizzy/services/matching_service/tournament_matching_service.dart';

import '../../../components/waiting_screen_widget.dart';

class SearchTournamentMatches extends StatefulWidget {
  final int questionsID;
  const SearchTournamentMatches({Key? key, required this.questionsID})
      : super(key: key);

  @override
  State<SearchTournamentMatches> createState() =>
      _SearchTournamentMatchesState();
}

class _SearchTournamentMatchesState extends State<SearchTournamentMatches> {
  final _fireStore = FirebaseFirestore.instance;
  final _tournamentMatching = TournamentMatchingService();
  bool inRoom = false;

  String gameRoom = "";
  String text = "Tournament matches are empty";

  createRoom() async {
    gameRoom = await _tournamentMatching.createTournament(
        creatorUid: userPointRankingModel.uid,
        name: userPointRankingModel.name,
        isBot: false);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TournamentWaitingRoom(
                  gameId: gameRoom,
                  questionId: widget.questionsID,
                )));
  }

  joinRoom({required String gameId}) async {
    await _tournamentMatching.joinTournament(
        name: userPointRankingModel.name,
        gameDocID: gameId,
        uid: userPointRankingModel.uid,
        isBot: false);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TournamentWaitingRoom(
                  questionId: widget.questionsID,
                  gameId: gameId,
                )));
  }

  joinGameDummy({required String gameId}) async {
    await _tournamentMatching.joinTournament(
        name: "NightWalker", gameDocID: gameId, uid: "uid7", isBot: true);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TournamentWaitingRoom(
                  questionId: widget.questionsID,
                  gameId: gameId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _fireStore
              .collection("tournamentMatch")
              .where("hasStarted", isEqualTo: false)
              .where("usersCount", isLessThan: 8)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Something went wrong with stream ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final snapshotDocs = snapshot.data!.docs;

            if (snapshotDocs.isEmpty) {
              if (inRoom == false) {
                createRoom();
                inRoom = true;
              }

              return waitingScreenWidget(
                bottomText: "Searching for tournament to join",
              );
            } else {
              if (inRoom == false) {
                joinRoom(gameId: snapshotDocs[0].id);
                //joinGameDummy(gameId: snapshotDocs[0].id);
                inRoom = true;
              }
              return waitingScreenWidget(
                bottomText: "Searching for tournament to join",
              );
            }
          }),
    );
  }
}
