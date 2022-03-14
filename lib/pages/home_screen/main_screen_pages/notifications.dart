import 'package:flutter/material.dart';

import '../../../constants.dart';

class Notifications extends StatefulWidget {
  static const String id = "notificationScreen";

  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationList> notificationList = [
    NotificationList(name: "Ahmed", accepted: false),
    NotificationList(name: "Mohammed", accepted: true),
    NotificationList(name: "Abdul", accepted: false),
    NotificationList(name: "Usman", accepted: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDefaultColor,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text(
          "Notifications",
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
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 70,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                child: ListView.separated(
                  itemCount: notificationList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundColor: kDefaultColor,
                      ),
                      title: Text(notificationList[index].name),
                      subtitle: Text(
                          "${notificationList[index].name} has invited you to play"),
                      trailing: notificationList[index].accepted
                          ? null
                          : TextButton(
                              onPressed: () {},
                              child: Container(
                                width: 95,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.lightBlueAccent[100],
                                ),
                                child: const Center(
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: kDefaultColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
