class TournamentUser {
  String name;
  String uid;
  int roomIndex;
  int score;
  bool isBot;

  TournamentUser({
    required this.name,
    required this.uid,
    required this.roomIndex,
    required this.score,
    required this.isBot,
  });
}

class TournamentPlayerNameScore {
  int score;
  String name;

  TournamentPlayerNameScore({required this.name, required this.score});
}
