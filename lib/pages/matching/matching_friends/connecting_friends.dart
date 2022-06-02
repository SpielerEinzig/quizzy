import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/services/database.dart';

import '../../../components/circle_avatar.dart';
import '../countdown.dart';

final _fireStore = FirebaseFirestore.instance;

class ConnectingFriends extends StatefulWidget {
  const ConnectingFriends({Key? key}) : super(key: key);

  @override
  _ConnectingFriendsState createState() => _ConnectingFriendsState();
}

class _ConnectingFriendsState extends State<ConnectingFriends> {
  String name = userPointRankingModel.name;
  String secondUser = "waiting...";
  bool gameStarted = false;

  checkGameStatus() {
    _fireStore
        .collection("games")
        .doc(userPointRankingModel.uid)
        .snapshots()
        .listen((event) {
      Map<String, dynamic>? roomInfo = event.data();

      gameStarted = roomInfo!["hasStarted"];

      if (gameStarted) {
        print("game started as hasStarted has been set to true");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CountDownPage(roomName: userPointRankingModel.uid)));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGameStatus();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _fireStore
              .collection("games")
              .doc(userPointRankingModel.uid)
              .collection(userPointRankingModel.uid)
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

            final userGameRoom = snapshot.data.docs;

            for (var usersDoc in userGameRoom) {
              String userName = usersDoc["name"];

              print(userName);

              if (userName != name) {
                secondUser = userName;
              }
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
