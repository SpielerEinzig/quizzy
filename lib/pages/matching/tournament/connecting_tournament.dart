import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/models/tournament_user.dart';
import 'package:quizzy/pages/matching/tournament/tournament_countdown.dart';
import 'package:quizzy/services/tournament.dart';

import '../../../components/tournament_pair_card.dart';

class ConnectingTournament extends StatefulWidget {
  final String gameRoom;

  const ConnectingTournament({Key? key, required this.gameRoom})
      : super(key: key);

  @override
  _ConnectingTournamentState createState() => _ConnectingTournamentState();
}

class _ConnectingTournamentState extends State<ConnectingTournament> {
  final _fireStore = FirebaseFirestore.instance;

  int usersInRoom = 0;

  List<TournamentUser> usersInTournamentRoom = [];

  listenForRoomFilled() {
    _fireStore
        .collection("tournament")
        .doc(widget.gameRoom)
        .collection(widget.gameRoom)
        .orderBy("roomIndex")
        .snapshots()
        .listen((snapshot) {
      usersInRoom = snapshot.docs.length;

      if (usersInRoom >= TournamentService().maxUsersInRoom) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TournamentCountDown(
                    usersInRoom: usersInTournamentRoom,
                    gameRoom: widget.gameRoom)));
      } else {
        print("Users in room: $usersInRoom");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForRoomFilled();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore
              .collection("tournament")
              .doc(widget.gameRoom)
              .collection(widget.gameRoom)
              .orderBy("roomIndex")
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final playersDocs = snapshot.data.docs;

            //usersInRoom = playersDocs.length;

            for (var player in playersDocs) {
              String name = player["name"];
              String uid = player["userId"];
              int roomIndex = player["roomIndex"];
              int score = player["score"];
              bool isBot = player["isBot"];

              TournamentUser value = TournamentUser(
                name: name,
                uid: uid,
                roomIndex: roomIndex,
                score: score,
                isBot: isBot,
              );

              usersInTournamentRoom.add(value);
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.34,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff7A5CF3),
                            Color(0xff658EF3),
                          ]),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )),
                  child: SafeArea(
                    child: Column(
                      children: [
                        AvatarGlow(
                          endRadius: 82,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: Center(
                                child: Text(
                              5.toString(),
                              style: const TextStyle(
                                fontSize: 47,
                              ),
                            )),
                          ),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Countdown",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 355,
                  //color: Colors.red,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 19,
                    crossAxisSpacing: 16,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    children: [
                      tournamentPairCard(
                        firstPlayer: usersInTournamentRoom.isNotEmpty
                            ? usersInTournamentRoom[0].name
                            : "Waiting",
                        secondPlayer: usersInTournamentRoom.length >= 2
                            ? usersInTournamentRoom[1].name
                            : "Waiting",
                        width: screenWidth * 0.44,
                        height: screenHeight * 0.23,
                      ),
                      tournamentPairCard(
                        firstPlayer: usersInTournamentRoom.length >= 3
                            ? usersInTournamentRoom[2].name
                            : "Waiting",
                        secondPlayer: usersInTournamentRoom.length >= 4
                            ? usersInTournamentRoom[3].name
                            : "Waiting",
                        width: screenWidth * 0.44,
                        height: screenHeight * 0.23,
                      ),
                      tournamentPairCard(
                        firstPlayer: usersInTournamentRoom.length >= 5
                            ? usersInTournamentRoom[4].name
                            : "Waiting",
                        secondPlayer: usersInTournamentRoom.length >= 6
                            ? usersInTournamentRoom[5].name
                            : "Waiting",
                        width: screenWidth * 0.44,
                        height: screenHeight * 0.23,
                      ),
                      tournamentPairCard(
                        firstPlayer: usersInTournamentRoom.length >= 7
                            ? usersInTournamentRoom[6].name
                            : "Waiting",
                        secondPlayer: usersInTournamentRoom.length >= 8
                            ? usersInTournamentRoom[7].name
                            : "Waiting",
                        width: screenWidth * 0.44,
                        height: screenHeight * 0.23,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
