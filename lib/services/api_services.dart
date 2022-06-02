import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/questions_model.dart';

List<String> iconPaths = [
  "assets/images/tournament_icons/science.png",
  "assets/images/tournament_icons/geography.png",
  "assets/images/tournament_icons/technology.png",
  "assets/images/tournament_icons/travel.png",
  "assets/images/tournament_icons/music.png",
  "assets/images/tournament_icons/art.png",
  "assets/images/tournament_icons/math.png",
  "assets/images/tournament_icons/sports.png",
  "assets/images/tournament_icons/history.png",
];

List<ApiCategoryObject> apiCategory = [];
//
//List of questions for category
List<QuestionsModel> questionList = [];

class APIService {
  getCategories() async {
    http.Response response = await http
        .get(Uri.parse("http://210.56.9.60/Quizzly/api/Category?isActive=1"));

    if (response.statusCode == 200) {
      var jsonData = await jsonDecode(response.body);

      for (var apiData in jsonData) {
        for (var path in iconPaths) {
          if (path.contains(apiData["CategoryName"].toLowerCase())) {
            ApiCategoryObject item = ApiCategoryObject(
                name: apiData["CategoryName"],
                id: apiData["CategoryId"],
                iconPath: path);

            apiCategory.contains(item) ? null : apiCategory.add(item);
          }
        }
      }
    } else {
      print("Fetch failed code: ${response.statusCode}");
    }

    return apiCategory;
  }

  getPriceConversion() async {
    http.Response response =
        await http.get(Uri.parse("http://210.56.9.60/Quizzly/api/Prices"));

    if (response.statusCode == 200) {
      var jsonData = await jsonDecode(response.body);

      int pointConversion = jsonData[0]["TotalPoint"];
      int moneyEquivalent = jsonData[0]["ConversionAmount"];

      double conversionRate = pointConversion / moneyEquivalent;

      int roundedConversion = conversionRate.round();

      return roundedConversion;
    } else {
      print("Fetch failed code: ${response.statusCode}");
    }
  }

  getQuizQuestions(
    String id,
  ) async {
    questionList.clear();

    http.Response response = await http.get(Uri.parse(
        "http://210.56.9.60/Quizzly/api/QuizContent?categoryId=$id&difficultId=1&isActive=1&totalQuestions=10"));

    if (response.statusCode == 200) {
      var jsonData = await jsonDecode(response.body);

      for (var item in jsonData) {
        List<String> preparedList = [
          item["option1"],
          item["option2"],
          item["option3"],
          item["option4"],
        ];

        preparedList.shuffle();

        var value = QuestionsModel(
          question: item["MainQuestion"],
          answer: item["Answer"],
          questionAnswered: false,
          options: preparedList,
        );

        questionList.add(value);
      }
    } else {
      print("Responnse code is ${response.statusCode}");
    }
  }
}

class ApiCategoryObject {
  String name;
  int id;
  String iconPath;

  ApiCategoryObject({
    required this.name,
    required this.id,
    required this.iconPath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiCategoryObject &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode;
}
