import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/single_match/single_match_results_page.dart';

import '../../../components/authentication_screen_components/gradient_button.dart';
import '../../../components/gradient_appbar.dart';
import '../../../components/questions_page.dart';
import '../../../constants.dart';
import '../../../models/container_indicator.dart';
import '../../../services/api_services.dart';
import '../../home_screen/home_screen.dart';

class SingleMatchQuestionsPage extends StatefulWidget {
  final String gameId;
  final bool createdGame;

  const SingleMatchQuestionsPage(
      {Key? key, required this.gameId, required this.createdGame})
      : super(key: key);

  @override
  State<SingleMatchQuestionsPage> createState() =>
      _SingleMatchQuestionsPageState();
}

class _SingleMatchQuestionsPageState extends State<SingleMatchQuestionsPage> {
  final _fireStore = FirebaseFirestore.instance;

  int currentQuestion = 0;
  int score = 0;
  int increment = 1;
  List<ContainerIndicatorModel> containerIndicatorList = [];
  bool buttonPressed = false;

  List<Color?> answerCardColor = [
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
  ];

  buildIndicatorList() {
    for (var item in questionList) {
      setState(() {
        containerIndicatorList
            .add(ContainerIndicatorModel(color: Colors.white));
      });
    }
  }

  nextQuestion() {
    setState(() {
      currentQuestion >= questionList.length - 1
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SingleMatchResultsPage(
                  createdGame: widget.createdGame,
                  score: score,
                  roomName: widget.gameId,
                  timeRemaining: _start,
                ),
              ),
            )
          : currentQuestion++;

      List<Color?> defaultCardColor = [
        Colors.grey[300],
        Colors.grey[300],
        Colors.grey[300],
        Colors.grey[300],
      ];

      answerCardColor.setAll(0, defaultCardColor);
    });
  }

  late Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SingleMatchResultsPage(
                score: score,
                roomName: widget.gameId,
                timeRemaining: _start,
                createdGame: widget.createdGame,
              ),
            ),
          );
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  setUserCompletedQuiz() async {
    if (widget.createdGame == true) {
      try {
        await _fireStore.collection("singleMatch").doc(widget.gameId).update({
          "firstPlayerDone": true,
        });
      } catch (e) {
        print(
            "Error in setUserCompleted method, error setting completed status: $e");
      }
    } else {
      try {
        await _fireStore.collection("singleMatch").doc(widget.gameId).update({
          "secondPlayerDone": true,
        });
      } catch (e) {
        print(
            "Error in setUserCompleted method, error setting completed status: $e");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildIndicatorList();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    setUserCompletedQuiz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> optionsList = questionList[currentQuestion].options;

    return Scaffold(
      body: Stack(
        children: [
          mainPageAppBars(context: context, title: ""),
          Container(
            alignment: const Alignment(0, -0.8),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${currentQuestion + 1}",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined),
                        const SizedBox(width: 4),
                        Text(_start.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: const Alignment(0, -0.65),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 9,
              child: ListView.builder(
                itemCount: containerIndicatorList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: containerIndicatorList[index].questionIndicator(),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: kStackPositioning,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        questionList[currentQuestion].question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: optionsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 7.0),
                              child: answerCard(
                                answer: optionsList[index],
                                color: answerCardColor[index],
                                onPressed: () {
                                  if (questionList[currentQuestion]
                                          .questionAnswered ==
                                      false) {
                                    setState(() {
                                      if (optionsList[index] ==
                                          questionList[currentQuestion]
                                              .answer) {
                                        score = score + increment;
                                        answerCardColor[index] = Colors.green;
                                        containerIndicatorList[currentQuestion]
                                            .color = Colors.green;
                                      } else {
                                        answerCardColor[index] = Colors.red;
                                        containerIndicatorList[currentQuestion]
                                            .color = Colors.red;
                                      }
                                      questionList[currentQuestion]
                                          .questionAnswered = true;
                                    });
                                  } else {}
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 7),
                      gradientButton(
                          label: "Continue",
                          context: context,
                          onPressed: () {
                            setState(() {
                              buttonPressed = true;
                              nextQuestion();
                            });
                          }),
                      const SizedBox(height: 15),
                      Center(
                        child: exitButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          },
                          label: "Exit",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
