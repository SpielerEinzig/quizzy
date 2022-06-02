import 'package:flutter/material.dart';
import 'package:quizzy/components/authentication_screen_components/gradient_button.dart';
import 'package:quizzy/components/gradient_appbar.dart';

import '../../../constants.dart';
import '../../../services/api_services.dart';

class Categories extends StatefulWidget {
  static const String id = "categories";
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final apiService = APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: const [
              AppbarContainer(title: "Choose Category"),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 150,
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
                ),
                child: FutureBuilder(
                    future: apiService.getCategories(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: Text("Loading..."));
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 6,
                                  crossAxisSpacing: 6,
                                  crossAxisCount: 3),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data == null) {
                              return const Center(child: Text("Loading..."));
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  //play quiz by category
                                  //print(apiCategory[index].name);
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE1E3FC),
                                    borderRadius: BorderRadius.circular(
                                        kDefaultBorderRadius),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              kDefaultBorderRadius),
                                          gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xff7765F2),
                                                Color(0xff6a82f2),
                                              ]),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            apiCategory[index].iconPath,
                                            height: 25,
                                            width: 25,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        apiCategory[index].name,
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              child: gradientButton(
                  label: "Accept", context: context, onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}
