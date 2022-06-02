class UserPointRankingModel {
  int point;
  int localRank;
  int worldRank;
  String name;
  String location;
  bool connecting;
  bool inGame;
  String uid;

  UserPointRankingModel({
    required this.point,
    required this.localRank,
    required this.worldRank,
    required this.name,
    required this.location,
    required this.connecting,
    required this.inGame,
    required this.uid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPointRankingModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
