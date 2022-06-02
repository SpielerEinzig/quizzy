class UserModel {
  String name;
  String uid;
  int point;
  String location;
  bool inGame;
  bool connecting;

  UserModel({
    required this.name,
    required this.point,
    required this.location,
    required this.connecting,
    required this.inGame,
    required this.uid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
