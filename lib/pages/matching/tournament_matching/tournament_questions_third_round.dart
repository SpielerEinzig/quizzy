import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/authentication_screen_components/gradient_button.dart';
import '../../../components/gradient_appbar.dart';
import '../../../components/questions_page.dart';
import '../../../constants.dart';
import '../../../models/container_indicator.dart';
import '../../../services/api_services.dart';
import '../../../services/database.dart';
import '../../home_screen/home_screen.dart';
import 'tournament_result_round_third.dart';

class TournamentQuestionsThirdRound extends StatefulWidget {
  final String gameId;
  final int questionId;
  const TournamentQuestionsThirdRound(
      {Key? key, required this.gameId, required this.questionId})
      : super(key: key);

  @override
  State<TournamentQuestionsThirdRound> createState() =>
      _TournamentQuestionsThirdRoundState();
}

class _TournamentQuestionsThirdRoundState
    extends State<TournamentQuestionsThirdRound> {
  final _fireStore = FirebaseFirestore.instance;
  final apiService = APIService();

  int currentQuestion = 0;
  int score = 0;
  int increment = 1;
  List<ContainerIndicatorModel> containerIndicatorList = [];
  bool buttonPressed = false;
  late Timer _timer;
  int _start = 60;

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
                  builder: (context) => TournamentResultRoundThree(
                        gameId: widget.gameId,
                        questionId: widget.questionId,
                      )),
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

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentResultRoundThree(
                gameId: widget.gameId,
                questionId: widget.questionId,
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

  setUserStartedGame() async {
    try {
      await _fireStore
          .collection("tournamentMatch")
          .doc(widget.gameId)
          .collection("match")
          .doc(userPointRankingModel.uid)
          .update({
        "inGame": true,
      });
    } catch (e) {
      print(e);
    }
  }

  setUserCompleted() async {
    try {
      await _fireStore
          .collection("tournamentMatch")
          .doc(widget.gameId)
          .collection("match")
          .doc(userPointRankingModel.uid)
          .update({
        "score": FieldValue.increment(score),
        "inGame": false,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildIndicatorList();
    setUserStartedGame();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    setUserCompleted();
    apiService.getTournamentQuestions(
      id: widget.questionId.toString(),
      finalRound: false,
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                        questionList[currentQuestion].answer) {
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
    ));
  }
}
