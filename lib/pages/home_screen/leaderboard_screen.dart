import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/gradient_appbar.dart';
import '../../components/home_screen_components/home_screen_statuscardicons.dart';
import '../../constants.dart';
import '../../services/database.dart';

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
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              mainPageAppBars(context: context, title: "Leaderboard"),
              const SizedBox(height: 70),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.39,
                child: ListView.builder(
                    itemCount: worldUsers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            isThreeLine: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            leading: const CircleAvatar(
                              radius: 30,
                              backgroundColor: kDefaultColor,
                              child: FlutterLogo(
                                size: 30,
                              ),
                            ),
                            title: Text(
                              worldUsers[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Porttitor.",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            trailing: Column(
                              children: [
                                const Text(
                                  "Points",
                                  style: TextStyle(
                                      color: kDefaultColor, fontSize: 10),
                                ),
                                Text(
                                  worldUsers[index].point.toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: kDefaultColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 110,
            child: Container(
              //height: MediaQuery.of(context).size.height * 0.34,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Badge",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12),
                              child: Image.asset(
                                "assets/images/leaderboard/badge1.png",
                                width: 60,
                              ),
                            ),
                            statusCardIcon(
                              iconPath: "assets/images/status_card/star.png",
                              label: "POINT",
                              value: userPointRankingModel.point.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 200, child: VerticalDivider()),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Image.asset(
                                "assets/images/leaderboard/badge2.png",
                                width: 70,
                              ),
                            ),
                            statusCardIcon(
                              iconPath: "assets/images/status_card/world.png",
                              label: "WORLD RANK",
                              value: userPointRankingModel.worldRank.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 200, child: VerticalDivider()),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/images/leaderboard/badge3.png",
                              width: 90,
                            ),
                            statusCardIcon(
                              iconPath:
                                  "assets/images/status_card/location.png",
                              label: "LOCAL RANK",
                              value: userPointRankingModel.localRank.toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
