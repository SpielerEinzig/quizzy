import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/home_screen_components/home_screen_appbar.dart';
import 'package:quizzy/components/home_screen_components/invite_friend_card.dart';
import 'package:quizzy/constants.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/add_friends.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/categories.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/notifications.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/tournament.dart';
import 'package:quizzy/pages/matching/connecting_players.dart';
import 'package:quizzy/services/api_services.dart';

import '../../../components/home_screen_components/home_screen_statuscard.dart';
import '../../../components/home_screen_components/play_tournament_card.dart';
import '../../../services/database.dart';

class MainScreen extends StatefulWidget {
  static const id = "mainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final apiService = APIService();
  final databaseService = DataBaseService();
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  bool testerStatus = false;

  // testFunction() async {
  //   print("starting test function");
  //   var testStream = FirebaseFirestore.instance
  //       .collection("test")
  //       .doc("tester")
  //       .snapshots()
  //       .listen((event) {
  //     Map<String, dynamic>? testInfo = event.data();
  //
  //     String testerName = testInfo!["name"];
  //     testerStatus = testInfo["status"];
  //
  //     setState(() {
  //       print("The tester is: $testerName and status is: $testerStatus");
  //
  //       if (testerStatus) {
  //         print("tester is true");
  //       } else {
  //         print("tester is false");
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                mainScreenAppBar(
                    menuButtonPressed: () async {
                      //await testFunction();
                    },
                    notificationButtonPressed: () {
                      Navigator.pushNamed(context, Notifications.id);
                    },
                    context: context),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Categories",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Categories.id);
                              },
                              child: const Text(
                                "See all",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 80,
                        child: FutureBuilder(
                            future: apiService.getCategories(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return const Center(child: Text("Loading..."));
                              } else {
                                return ListView.builder(
                                    controller: ScrollController(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            var id = apiCategory[index].id;

                                            id = 1;

                                            await apiService.getQuizQuestions(
                                                id.toString());

                                            Navigator.pushNamed(
                                                context, ConnectPlayers.id);
                                          },
                                          child: Container(
                                            width: width * 0.21,
                                            height: height * 0.11,
                                            padding: const EdgeInsets.fromLTRB(
                                                3, 8, 3, 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kDefaultBorderRadius),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            kDefaultBorderRadius),
                                                    gradient:
                                                        const LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                          Color(0xff7B5CF3),
                                                          Color(0xff5F9EF3),
                                                        ]),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      apiCategory[index]
                                                          .iconPath,
                                                      width: width * 0.05,
                                                      height: height * 0.027,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  apiCategory[index].name,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                inviteFriend(
                  onTapped: () {
                    Navigator.pushNamed(context, AddFriends.id);
                  },
                ),
                const SizedBox(height: 17),
                playTournamentCard(
                  onTapped: () {
                    Navigator.pushNamed(context, Tournament.id);
                  },
                ),
              ],
            ),
            FutureBuilder(
                future: databaseService.statusCardServices(
                    userId: loggedInUser!.uid),
                builder: (context, AsyncSnapshot snapshot) {
                  return homeScreenStatusCard(
                    localRank: userPointRankingModel.localRank,
                    worldRank: userPointRankingModel.worldRank,
                    point: userPointRankingModel.point,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
