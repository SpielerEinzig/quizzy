import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/gradient_appbar.dart';
import 'package:quizzy/pages/matching/matching_friends/connecting_friends.dart';
import 'package:quizzy/services/invite_friend.dart';

import '../../../constants.dart';
import '../../../services/api_services.dart';
import '../../../services/database.dart';

final _fireStore = FirebaseFirestore.instance;

class AddFriends extends StatefulWidget {
  static const String id = "addFriends";

  const AddFriends({Key? key}) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  final MatchingFriendService _matchingFriendService = MatchingFriendService();

  final apiService = APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: const [
              AppbarContainer(title: "Add Friends"),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: kStackPositioning,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xffE1E4FC),
                      ),
                      child: TextField(
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          labelText: 'Search friend',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView.builder(
                          itemCount: worldUsers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: kDefaultColor,
                                  ),
                                  Text(worldUsers[index].name),
                                  TextButton(
                                    onPressed: () async {
                                      //create game room
                                      await _matchingFriendService
                                          .createGameToPlayWithFriend(
                                              creatorUid:
                                                  userPointRankingModel.uid,
                                              senderName:
                                                  userPointRankingModel.name);

                                      //send invite to friend's notification
                                      await _matchingFriendService.sendInvite(
                                        senderName: userPointRankingModel.name,
                                        senderUid: userPointRankingModel.uid,
                                        valid: true,
                                        timeSent: DateTime.now(),
                                        friendUid: worldUsers[index].uid,
                                        friendAccepted: false,
                                      );

                                      //get questions list from api
                                      int id = 1;

                                      await apiService
                                          .getQuizQuestions(id.toString());

                                      //navigate to next page after everything is complete
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ConnectingFriends()));
                                    },
                                    child: Container(
                                      width: 85,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            kDefaultBorderRadius),
                                        color: const Color(0xffE1E3FC),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Invite",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff6F77F3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
