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

class TournamentMatchUser {
  String name;
  String uid;
  int score;
  bool inGame;
  bool isBot;

  TournamentMatchUser(
      {required this.uid,
      required this.name,
      required this.score,
      required this.inGame,
      required this.isBot});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TournamentMatchUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}

class TournamentMatchPair {
  TournamentMatchUser first;
  TournamentMatchUser second;

  TournamentMatchPair({required this.first, required this.second});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TournamentMatchPair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode;
}
