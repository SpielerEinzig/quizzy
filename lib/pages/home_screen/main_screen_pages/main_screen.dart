import 'package:flutter/material.dart';
import 'package:quizzy/components/home_screen_components/home_screen_appbar.dart';
import 'package:quizzy/components/home_screen_components/invite_friend_card.dart';
import 'package:quizzy/constants.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/add_friends.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/categories.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/notifications.dart';
import 'package:quizzy/pages/home_screen/main_screen_pages/tournament.dart';

import '../../../components/home_screen_components/home_screen_statuscard.dart';
import '../../../components/home_screen_components/play_tournament_card.dart';

class MainScreen extends StatefulWidget {
  static const id = "mainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeScreenAppBar(notificationButtonPressed: () {
        Navigator.pushNamed(context, Notifications.id);
      }),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2 - 50,
                decoration: const BoxDecoration(
                  color: kDefaultColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Categories.id);
                            },
                            child: const Text(
                              "See all",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            controller: ScrollController(),
                            itemCount: quizCategoryList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  width: 90,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[200],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: kDefaultColor,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            quizCategoryList[index].icon,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(quizCategoryList[index].label),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
              inviteFriend(
                onTapped: () {
                  Navigator.pushNamed(context, AddFriends.id);
                },
              ),
              playTournamentCard(
                onTapped: () {
                  Navigator.pushNamed(context, Tournament.id);
                },
              ),
            ],
          ),
          homeScreenStatusCard(
            localRank: 650,
            worldRank: 1860,
            point: 2560,
          ),
        ],
      ),
    );
  }
}
