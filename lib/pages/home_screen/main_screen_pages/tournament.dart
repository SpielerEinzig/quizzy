import 'package:flutter/material.dart';
import 'package:quizzy/components/gradient_appbar.dart';
import 'package:quizzy/pages/matching/tournament/connecting_tournament.dart';
import 'package:quizzy/pages/matching/tournament/search_tournament.dart';
import 'package:quizzy/services/tournament.dart';

import '../../../constants.dart';
import '../../../services/api_services.dart';

class Tournament extends StatefulWidget {
  static const String id = "tournament";
  const Tournament({Key? key}) : super(key: key);

  @override
  _TournamentState createState() => _TournamentState();
}

class _TournamentState extends State<Tournament> {
  final apiService = APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: const [
              AppbarContainer(title: "Tournament"),
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
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                child: FutureBuilder(
                    future: apiService.getCategories(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: Text("Loading..."));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data == null) {
                              return const Center(child: Text("Loading..."));
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: const LinearGradient(colors: [
                                          Color(0xff7765F2),
                                          Color(0xff6a82f2),
                                        ]),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          apiCategory[index].iconPath,
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                    //const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          apiCategory[index].name,
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        const Text(
                                          "Lorem ipsum dolor sit amet.",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        var id = apiCategory[index].id;
                                        id = 1;

                                        await TournamentService()
                                            .getTournamentQuestions(
                                          id: id,
                                          finalRound: true,
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchTournament(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 97,
                                        height: 47,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xffE1E3FC),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Start",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xff6f77f2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
