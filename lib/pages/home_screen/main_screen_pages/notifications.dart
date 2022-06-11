import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/matching_friends/matching_friends_countdown.dart';
import 'package:quizzy/services/database.dart';
import 'package:quizzy/services/matching_service/friend_matching_service.dart';

import '../../../components/acceptButton.dart';
import '../../../components/gradient_appbar.dart';
import '../../../constants.dart';
import '../../../services/api_services.dart';

class Notifications extends StatefulWidget {
  static const String id = "notificationScreen";

  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _fireStore = FirebaseFirestore.instance;
  final _friendMatchingService = FriendMatchingService();
  final apiService = APIService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: const [
              AppbarContainer(
                title: "Notifications",
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: kStackPositioning,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.73,
                width: MediaQuery.of(context).size.width * 0.92,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                child: StreamBuilder<QuerySnapshot>(
                    stream: _fireStore
                        .collection("notifications")
                        .where("inviteeUid",
                            isEqualTo: userPointRankingModel.uid)
                        .orderBy("timeSent", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final invites = snapshot.data!.docs;

                      return ListView.separated(
                        itemCount: invites.length,
                        itemBuilder: (context, index) {
                          int minuteDifference = DateTime.now()
                              .difference(invites[index]["timeSent"].toDate())
                              .inMinutes;
                          int hourDifference = DateTime.now()
                              .difference(invites[index]["timeSent"].toDate())
                              .inHours;
                          int dayDifference = DateTime.now()
                              .difference(invites[index]["timeSent"].toDate())
                              .inDays;

                          String timeSent = "";

                          if (dayDifference > 0) {
                            timeSent = "$dayDifference days ago";
                          } else if (hourDifference > 0) {
                            timeSent = "$hourDifference hours ago";
                          } else {
                            timeSent = "$minuteDifference minutes ago";
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 26,
                                    backgroundColor: kDefaultColor,
                                    backgroundImage:
                                        AssetImage("assets/images/person.png"),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          invites[index]["inviterName"],
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          "${invites[index]["inviterName"]} has \ninvited you to play",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ]),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    timeSent,
                                    style: const TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),
                                  invites[index]["inviteValid"]
                                      ? acceptButton(onPressed: () async {
                                          //get questions list from api
                                          int id = 1;

                                          await apiService
                                              .getQuizQuestions(id.toString());

                                          //print(invites[index]["gameId"]);

                                          //join friend's game from matching service
                                          await _friendMatchingService
                                              .joinFriendlyGame(
                                            gameId: invites[index]["gameId"],
                                            userId: userPointRankingModel.uid,
                                            userName:
                                                userPointRankingModel.name,
                                          );

                                          //navigate to page after services are complete
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MatchingFriendsCountdown(
                                                createdGame: false,
                                                gameId: invites[index]
                                                    ["gameId"],
                                              ),
                                            ),
                                          );
                                        })
                                      : const SizedBox(width: 85, height: 55),
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Colors.black54,
                          );
                        },
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
