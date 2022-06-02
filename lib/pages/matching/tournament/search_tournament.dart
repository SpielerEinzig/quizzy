import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/services/tournament.dart';

import '../../../components/circle_avatar.dart';
import '../../../models/tournament_list.dart';
import '../../../services/database.dart';

class SearchTournament extends StatefulWidget {
  const SearchTournament({Key? key}) : super(key: key);

  @override
  _SearchTournamentState createState() => _SearchTournamentState();
}

class _SearchTournamentState extends State<SearchTournament> {
  final _fireStore = FirebaseFirestore.instance;
  final _tournamentService = TournamentService();

  String name = userPointRankingModel.name;
  String secondUser = "Searching";

  List<TournamentList> availableTournamentMatches = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool joinedGame = false;
    bool createdGame = false;

    joinGame() async {
      joinedGame = true;

      await _tournamentService.joinGame(
        context: context,
        userId: userPointRankingModel.uid,
        userName: userPointRankingModel.name,
        isBot: false,
        gameId: availableTournamentMatches[0].roomName,
      );
    }

    createNewTournament() async {
      await _tournamentService.createTournament(
        userId: userPointRankingModel.uid,
        userName: userPointRankingModel.name,
      );

      createdGame = true;
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection("tournament").snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final tournamentMatches = snapshot.data.docs;

            for (var tournamentMatch in tournamentMatches) {
              TournamentList tournamentRoom = TournamentList(
                roomName: tournamentMatch.id,
                hasStarted: tournamentMatch["hasStarted"],
              );

              if (tournamentRoom.hasStarted == false) {
                availableTournamentMatches.add(tournamentRoom);
              }
            }

            if (availableTournamentMatches.isNotEmpty) {
              if (joinedGame == false && createdGame == false) {
                joinGame();
              }
            } else {
              createNewTournament();
            }

            return Stack(
              children: [
                Container(
                  alignment: const Alignment(0, -0.9),
                  child: Container(
                    width: screenWidth * 0.92,
                    height: 101,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAEAFC),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/images/trophy3d.png"),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("You have earned an award"),
                                Text(
                                  "Tournament winner",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: AvatarGlow(
                    endRadius: 150,
                    glowColor: Color(0xff6C7FF3),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xff6C7FF3),
                      child: Center(
                        child: Text("VS"),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: const Alignment(0, 0.7),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text("Connecting..."),
                  ),
                ),
                avatarCircle(x: -0.5, y: -0.37),
                Container(
                    alignment: const Alignment(-0.5, -0.22), child: Text(name)),
                avatarCircle(x: 0.5, y: 0.37),
                Container(
                    alignment: const Alignment(0.5, 0.47),
                    child: Text(secondUser)),
              ],
            );
          }),
    );
  }
}
