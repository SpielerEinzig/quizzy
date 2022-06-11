import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/components/gradient_appbar.dart';
import 'package:quizzy/models/user_model.dart';
import 'package:quizzy/pages/matching/matching_friends/connecting_friends.dart';
import 'package:quizzy/services/matching_service/friend_matching_service.dart';

import '../../../constants.dart';
import '../../../services/api_services.dart';
import '../../../services/database.dart';

class AddFriends extends StatefulWidget {
  static const String id = "addFriends";

  const AddFriends({Key? key}) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  final _fireStore = FirebaseFirestore.instance;
  final _friendMatchingService = FriendMatchingService();
  final apiService = APIService();

  String query = "";
  List<UserModel> queriedUsers = [];

  searchUsers({required String queryText}) async {
    queriedUsers.clear();

    List<UserModel> generatedQueryList = [];

    for (var user in worldUsers) {
      if (user.name.toLowerCase().contains(queryText.toLowerCase())) {
        generatedQueryList.add(user);
      }
    }

    queriedUsers = generatedQueryList;

    setState(() {});
  }

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
                      //height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xffE1E4FC),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          query = value;

                          searchUsers(queryText: value);
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintText: 'Search friend',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView.builder(
                          itemCount: queriedUsers.isEmpty
                              ? worldUsers.length
                              : queriedUsers.length,
                          itemBuilder: (context, index) {
                            return inviteUserListTile(
                              name: queriedUsers.isEmpty
                                  ? worldUsers[index].name
                                  : queriedUsers[index].name,
                              inviteButtonPressed: () async {
                                //get questions list from api
                                int id = 1;

                                await apiService
                                    .getQuizQuestions(id.toString());

                                //create game room
                                final gameCreated = await _friendMatchingService
                                    .createFriendlyGame(
                                        userId: userPointRankingModel.uid,
                                        timeCreated: DateTime.now(),
                                        userName: userPointRankingModel.name,
                                        inviteUid: queriedUsers.isEmpty
                                            ? worldUsers[index].uid
                                            : queriedUsers[index].uid,
                                        inviteName: queriedUsers.isEmpty
                                            ? worldUsers[index].name
                                            : queriedUsers[index].name);

                                String gameId = gameCreated.id;

                                //send invite to friend's notification
                                final inviteRef = await _friendMatchingService
                                    .sendInviteToFriend(
                                  inviteeName: queriedUsers.isEmpty
                                      ? worldUsers[index].name
                                      : queriedUsers[index].name,
                                  inviterName: userPointRankingModel.name,
                                  inviterUid: userPointRankingModel.uid,
                                  inviteeUid: queriedUsers.isEmpty
                                      ? worldUsers[index].uid
                                      : queriedUsers[index].uid,
                                  gameDocId: gameId,
                                  timeSent: DateTime.now(),
                                );

                                //navigate to next page after everything is complete
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConnectingFriends(
                                              inviteId: inviteRef.id,
                                              gameDocId: gameId,
                                              isCreator: true,
                                            )));
                              },
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

Widget inviteUserListTile({
  required String name,
  required Function() inviteButtonPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: kDefaultColor,
          backgroundImage: AssetImage("assets/images/person.png"),
        ),
        Text(name),
        TextButton(
          onPressed: inviteButtonPressed,
          child: Container(
            width: 85,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
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
}
