import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/countdown.dart';
import 'package:quizzy/services/database.dart';

import '../../../components/gradient_appbar.dart';
import '../../../constants.dart';
import '../../../services/api_services.dart';
import '../../../services/invite_friend.dart';

class Notifications extends StatefulWidget {
  static const String id = "notificationScreen";

  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _fireStore = FirebaseFirestore.instance;
  bool userDocExists = false;

  final apiService = APIService();

  List<NotificationList> notificationList = [
    // NotificationList(name: "Ahmed", accepted: false),
    // NotificationList(name: "Mohammed", accepted: true),
    // NotificationList(name: "Abdul", accepted: false),
    // NotificationList(name: "Usman", accepted: true),
  ];

  // String getNotificationTime(DateTime timeSent) {
  //   int minuteDifference = DateTime.now().difference(timeSent).inMinutes;
  //
  //   if (minuteDifference > 59 && minuteDifference < 1440) {
  //     double roundHourDifference = minuteDifference / 60;
  //     int hourDifference = roundHourDifference.round();
  //     String hourMessage = "$hourDifference hours ago";
  //     return hourMessage;
  //   } else if (minuteDifference > 1440) {
  //     double roundDayDifference = minuteDifference / 1440;
  //     int dayDifference = roundDayDifference.round();
  //
  //     String dayMessage = "$dayDifference days ago";
  //     return dayMessage;
  //   } else {
  //     String minuteMessage = "$minuteDifference minutes ago";
  //     return minuteMessage;
  //   }
  // }

  checkUserNotificationDocumentExists() async {
    try {
      await _fireStore
          .collection('notifications')
          .doc(userPointRankingModel.uid)
          .get()
          .then((userDoc) {
        userDocExists = userDoc.exists;
        print("The user doc exists? $userDocExists");
      });

      if (userDocExists == false) {
        print(
            "user notification document does not exist, creating new document");
        try {
          await MatchingFriendService().sendInvite(
            senderName: "Adnan",
            senderUid: userPointRankingModel.uid,
            valid: false,
            timeSent: DateTime.now(),
            friendUid: userPointRankingModel.uid,
            friendAccepted: false,
          );
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserNotificationDocumentExists();
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
                        .doc(userPointRankingModel.uid)
                        .collection(userPointRankingModel.uid)
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

                      for (var invite in invites) {
                        DateTime timeSent = invite["timeSent"].toDate();

                        final singleInvite = NotificationList(
                          name: invite["sender"],
                          senderUid: invite["senderUid"],
                          timeSent: timeSent,
                          valid: invite["valid"],
                        );

                        if (notificationList.contains(singleInvite)) {
                          print("Already exists in list");
                        } else {
                          notificationList.add(singleInvite);
                        }
                      }

                      return ListView.separated(
                        itemCount: notificationList.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              const CircleAvatar(
                                radius: 26,
                                backgroundColor: kDefaultColor,
                              ),
                              const SizedBox(width: 20),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notificationList[index].name,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "${notificationList[index].name} has \ninvited you to play",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ]),
                              const SizedBox(width: 40),
                              Column(
                                children: [
                                  Text(
                                    "${DateTime.now().difference(notificationList[index].timeSent).inMinutes} minutes ago",
                                    style: const TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),
                                  notificationList[index].valid
                                      ? acceptButton(onPressed: () async {
                                          print(
                                              "The sender uid is: ${notificationList[index].senderUid}");
                                          //get questions list from api
                                          int id = 1;

                                          await apiService
                                              .getQuizQuestions(id.toString());

                                          //join friend's game from matching service
                                          await MatchingFriendService()
                                              .joinFriendsGame(
                                            creatorUid: notificationList[index]
                                                .senderUid,
                                            userUid: userPointRankingModel.uid,
                                            userName:
                                                userPointRankingModel.name,
                                          );

                                          //navigate to page after services are complete
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CountDownPage(
                                                      roomName:
                                                          notificationList[
                                                                  index]
                                                              .senderUid),
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

Widget acceptButton({required Function() onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Container(
      width: 85,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: const Color(0xffE1E3FC),
      ),
      child: const Center(
        child: Text(
          "Accept",
          style: TextStyle(
            fontSize: 15,
            color: kDefaultColor,
          ),
        ),
      ),
    ),
  );
}
