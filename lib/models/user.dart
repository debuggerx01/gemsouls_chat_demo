import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  int uid;
  @HiveField(1)
  String nickname;
  @HiveField(2)
  String? avatar;

  User({
    required this.uid,
    required this.nickname,
    this.avatar,
  });
}
