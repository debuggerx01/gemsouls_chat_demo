import 'package:gemsouls_chat_demo/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'conversation.g.dart';

@HiveType(typeId: 2)
class Conversation {
  @HiveField(0)
  int from;
  @HiveField(1)
  int to;
  @HiveField(2)
  Msg? lastMsg;

  Conversation({
    required this.from,
    required this.to,
    this.lastMsg,
  });
}
