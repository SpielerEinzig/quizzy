import 'package:flutter/material.dart';
import 'package:quizzy/components/gradient_appbar.dart';
import 'package:quizzy/services/api_services.dart';

import '../../constants.dart';
import '../../services/database.dart';

class Withdraw extends StatefulWidget {
  static const String id = "withdrawScreen";

  const Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  int withdrawAmount = 0;

  double userMoney = 100;

  getUserMoney() async {
    double gottenUserMoney = await DataBaseService().fetchTotalDollar();

    setState(() {
      userMoney = gottenUserMoney;
    });

    print("user money is $userMoney");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserMoney();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [mainPageAppBars(context: context, title: "Withdraw")],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 150,
            child: Container(
              height: 360,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      labelValueColumn(
                          label: "Points",
                          value: userPointRankingModel.point.toString()),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff8E8AF4),
                        ),
                        child: CircleAvatar(
                          backgroundColor: kDefaultColor,
                          radius: 25,
                          child: Center(
                            child: Image.asset(
                              "assets/images/leaderboard/send.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      labelValueColumn(
                        label: "Dollar",
                        value: userMoney.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(kDefaultBorderRadius),
                        ),
                        child: Center(
                          child: Image.asset(
                              "assets/images/social_icons/paypal.png"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text("Enter Amount"),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              onChanged: (value) {
                                withdrawAmount = int.parse(value);
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          //process payment
                          print("implement process payment");
                        },
                        child: Container(
                          height: 60,
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff7666F3),
                                Color(0xff658CF3),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(kDefaultBorderRadius),
                          ),
                          child: const Center(
                            child: Text(
                              "PROCESS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
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
