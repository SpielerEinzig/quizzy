import 'package:flutter/material.dart';

import '../../components/home_screen_components/home_screen_statuscard.dart';
import '../../constants.dart';

class LeaderBoardScreen extends StatefulWidget {
  static const String id = "leaderboardScreen";

  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDefaultColor,
        title: const Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2 - 30,
                decoration: const BoxDecoration(
                  color: kDefaultColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2 + 20,
                child: ListView.builder(
                    itemCount: leaderBoardList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundColor: kDefaultColor,
                            child: FlutterLogo(
                              size: 30,
                            ),
                          ),
                          title: Text(leaderBoardList[index].name),
                          trailing: Column(
                            children: [
                              const Text(
                                "Points",
                                style: TextStyle(
                                  color: kDefaultColor,
                                ),
                              ),
                              Text(
                                leaderBoardList[index].points.toString(),
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: kDefaultColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
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
