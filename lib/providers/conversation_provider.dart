import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/models/conversation.dart';
import 'package:gemsouls_chat_demo/models/message.dart';
import 'package:gemsouls_chat_demo/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConversationProvider extends StateNotifier<Conversation?> {
  ConversationProvider() : super(null);
  late Box<Conversation> _conversationBox;
  late int _fromUid;

  late Box<Msg> _msgBox;

  late User toUser;

  String get title => 'Chatting with [${toUser.nickname}]';

  Msg? get lastMsg => state?.lastMsg;

  Future loadByFromUid(int fromUid) async {
    _fromUid = fromUid;
    _conversationBox = await Hive.openBox<Conversation>('user:$fromUid');
  }

  Conversation? getConversationByToUid(int toUid) => _conversationBox.get('user:$toUid');

  Future startConversation(User toUser, [bool create = false]) async {
    this.toUser = toUser;
    if (create) {
      state = Conversation(
        from: _fromUid,
        to: toUser.uid,
        lastMsg: null,
      );
      _updateConversations();
    } else {
      state = _conversationBox.get('user:${toUser.uid}')!;
    }

    _msgBox = await Hive.openBox<Msg>(
      'conversation:${([_fromUid, toUser.uid]..sort()).join('-')}',
    );
  }

  _updateConversations() {
    _conversationBox.put(
      'user:${toUser.uid}',
      state!,
    );

    Hive.openBox<Conversation>('user:${toUser.uid}').then((box) {
      box.put(
        'user:$_fromUid',
        state!,
      );
      box.close();
    });
  }

  Msg addMsg({
    required int from,
    required int to,
    required String msg,
    required MsgType msgType,
  }) {
    var preMsgId = state?.lastMsg?.msgId;
    var newMsg = Msg(
      msgId: preMsgId == null ? 0 : preMsgId + 1,
      preMsgId: preMsgId,
      from: from,
      to: to,
      msgType: msgType,
      msg: msg,
      timestamp: DateTime.now(),
    );

    _msgBox.put(preMsgId == null ? 0 : preMsgId + 1, newMsg);
    state?.lastMsg = newMsg;

    _updateConversations();

    return newMsg;
  }

  Msg? getMsgById(int msgId) => _msgBox.get(msgId);

  void stopConversation() {
    state = null;
  }

  void updateMsg(Msg msg) {
    _msgBox.put(msg.msgId, msg);
    if (msg.msgId == lastMsg?.msgId) {
      state?.lastMsg = msg;
      _updateConversations();
    }
  }
}
