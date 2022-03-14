import 'package:flutter/material.dart';

import '../../constants.dart';

class Withdraw extends StatefulWidget {
  static const String id = "withdrawScreen";

  const Withdraw({Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  int withdrawAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kDefaultColor,
        title: const Text(
          "Withdraw Money",
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
            child: Container(
              height: 360,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      labelValueColumn(label: "Points", value: "889524"),
                      const CircleAvatar(
                        backgroundColor: kDefaultColor,
                        radius: 30,
                        child: Icon(Icons.send),
                      ),
                      labelValueColumn(label: "Points", value: "\$1500"),
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
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 10),
                              blurRadius: 50,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          height: 70,
                          width: 130,
                          decoration: BoxDecoration(
                            color: kDefaultColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 10),
                                blurRadius: 50,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "PROCESS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
