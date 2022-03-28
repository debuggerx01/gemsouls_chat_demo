import 'package:hive_flutter/hive_flutter.dart';

part 'message.g.dart';

@HiveType(typeId: 4)
enum MsgType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
}

@HiveType(typeId: 3)
class Msg {
  @HiveField(0)
  final int? msgId;
  @HiveField(1)
  final int? preMsgId;
  @HiveField(2)
  final int from;
  @HiveField(3)
  final int to;
  @HiveField(4)
  final MsgType msgType;
  @HiveField(5)
  final String msg;
  @HiveField(6)
  final DateTime timestamp;
  @HiveField(7)
  final List<int>? likedIds;

  const Msg({
    required this.msgId,
    required this.preMsgId,
    required this.from,
    required this.to,
    required this.msg,
    required this.timestamp,
    this.msgType = MsgType.text,
    this.likedIds,
  });

  String get displayMsg {
    switch (msgType) {
      case MsgType.text:
        return msg;
      case MsgType.image:
        return '[Image]';
    }
  }
}
