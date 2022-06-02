import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizzy/pages/matching/tournament/tournamentResults.dart';
import 'package:quizzy/services/tournament.dart';

import '../../../components/authentication_screen_components/gradient_button.dart';
import '../../../components/gradient_appbar.dart';
import '../../../components/questions_page.dart';
import '../../../constants.dart';
import '../../../models/container_indicator.dart';
import '../../home_screen/home_screen.dart';

class TournamentQuestionsPage extends StatefulWidget {
  final String roomName;
  const TournamentQuestionsPage({Key? key, required this.roomName})
      : super(key: key);

  @override
  _TournamentQuestionsPageState createState() =>
      _TournamentQuestionsPageState();
}

class _TournamentQuestionsPageState extends State<TournamentQuestionsPage> {
  int currentQuestion = 0;
  int score = 0;
  int increment = 5;
  List<ContainerIndicatorModel> containerIndicatorList = [];
  bool buttonPressed = false;

  final tournamentQuestions = tournamentQuestionsList;

  List<Color?> answerCardColor = [
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
    Colors.grey[300],
  ];

  buildIndicatorList() {
    for (var item in tournamentQuestions) {
      print(item.answer);
      setState(() {
        containerIndicatorList
            .add(ContainerIndicatorModel(color: Colors.white));
      });
    }
  }

  nextQuestion() {
    setState(() {
      currentQuestion >= tournamentQuestions.length - 1
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TournamentResults(
                  score: score,
                  roomName: widget.roomName,
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

  late Timer timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentResults(
                score: score,
                roomName: widget.roomName,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> optionsList = tournamentQuestions[currentQuestion].options;

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
                        tournamentQuestions[currentQuestion].question,
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
                                  if (tournamentQuestions[currentQuestion]
                                          .questionAnswered ==
                                      false) {
                                    setState(() {
                                      if (optionsList[index] ==
                                          tournamentQuestions[currentQuestion]
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
                                      tournamentQuestions[currentQuestion]
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
