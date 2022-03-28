import 'dart:async';
import 'dart:math' show min;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/main.dart';
import 'package:gemsouls_chat_demo/models/message.dart';
import 'package:gemsouls_chat_demo/models/user.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _editTextCtl = TextEditingController();
  final _listViewCtl = ScrollController();

  late List<Msg> messages;

  @override
  void initState() {
    messages = [];
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      var lastMsg = ref.read(conversationProvider.notifier).lastMsg;
      if (lastMsg != null) {
        setState(() {
          messages = [lastMsg];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var conversation = ref.watch(conversationProvider.notifier);
    var self = ref.watch(currentUserProvider.notifier).currentUser;

    void _sendMessage(User from, User to, MsgType type, String msg) {
      var _msg = conversation.addMsg(from: from.uid, to: to.uid, msg: msg, msgType: type);
      messages.insert(0, _msg);
      moveToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(conversation.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) => ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth, maxHeight: constraints.maxHeight),
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: _listViewCtl,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == messages.length - 1 && messages.last.preMsgId != null) {
                      var msg = conversation.getMsgById(messages.last.preMsgId!);
                      if (msg != null) {
                        Future.microtask(() {
                          if (mounted) {
                            setState(() {
                              messages.add(msg);
                            });
                          }
                        });
                      }
                    }
                    var msg = messages[index];
                    bool isSelf = msg.from == self.uid;
                    var name = isSelf ? self.nickname : conversation.toUser.nickname;
                    var avatar = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30.0,
                        foregroundImage: CachedNetworkImageProvider(
                          isSelf ? self.avatar! : conversation.toUser.avatar!,
                        ),
                      ),
                    );

                    var holder = Flexible(
                      flex: 2,
                      child: Container(),
                    );

                    return Container(
                      padding: const EdgeInsets.all(5.0),
                      width: double.infinity,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          isSelf ? holder : avatar,
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: isSelf ? Alignment.centerRight : Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(name),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: ((reverse) {
                                        var children = [
                                          CustomPaint(
                                            painter: MsgBackGround(isSelf),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: min(MediaQuery.of(context).size.width / 3, 300)),
                                                child: msg.msgType == MsgType.text
                                                    ? SelectableText(msg.msg)
                                                    : CachedNetworkImage(
                                                        imageUrl: msg.msg,
                                                        width: min(MediaQuery.of(context).size.width / 2, 300),
                                                        placeholder: (_, __) => Card(
                                                          color: Colors.white.withOpacity(.5),
                                                          child: SizedBox(
                                                            height: min(MediaQuery.of(context).size.width / 4, 300),
                                                            child: const Center(
                                                              child: CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: isSelf
                                                ? null
                                                : () {
                                                    setState(() {
                                                      var likedIds = messages[index].likedIds ?? [];
                                                      if (likedIds.contains(self.uid)) {
                                                        likedIds.remove(self.uid);
                                                      } else {
                                                        likedIds.add(self.uid);
                                                      }
                                                      messages[index] = Msg(
                                                        msgId: messages[index].msgId,
                                                        preMsgId: messages[index].preMsgId,
                                                        from: messages[index].from,
                                                        to: messages[index].to,
                                                        msg: messages[index].msg,
                                                        msgType: messages[index].msgType,
                                                        timestamp: messages[index].timestamp,
                                                        likedIds: likedIds,
                                                      );
                                                      conversation.updateMsg(messages[index]);
                                                    });
                                                  },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: (msg.likedIds ?? []).isNotEmpty
                                                  ? const Icon(
                                                      Icons.thumb_up,
                                                      color: Colors.orange,
                                                    )
                                                  : Icon(
                                                      Icons.thumb_up_alt_outlined,
                                                      color: Colors.orange.shade300,
                                                    ),
                                            ),
                                          ),
                                        ];
                                        if (reverse) {
                                          return children.reversed.toList();
                                        }
                                        return children;
                                      })(isSelf),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            flex: 8,
                          ),
                          !isSelf ? holder : avatar,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 100.0),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              padding: const EdgeInsets.all(5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      var fakerImage = Faker(seed: DateTime.now().millisecondsSinceEpoch).image;
                      setState(() {
                        _sendMessage(self, conversation.toUser, MsgType.image, fakerImage.image(random: true));
                      });

                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _sendMessage(conversation.toUser, self, MsgType.image, fakerImage.image(random: true));
                        });
                      });
                    },
                    icon: const Icon(Icons.image),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: TextField(
                        controller: _editTextCtl,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_editTextCtl.text.trim().isNotEmpty) {
                        var msgContent = _editTextCtl.text.trim();
                        setState(() {
                          _sendMessage(self, conversation.toUser, MsgType.text, msgContent);
                        });

                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            _sendMessage(conversation.toUser, self, MsgType.text, msgContent);
                          });
                        });

                        _editTextCtl.text = '';
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveToBottom() {
    Timer(Duration.zero, () {
      _listViewCtl.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }
}

class MsgBackGround extends CustomPainter {
  final bool isSelf;

  MsgBackGround(this.isSelf);

  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = isSelf ? Colors.green : Colors.grey
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromLTRBR(
          0.0,
          0.0,
          size.width,
          size.height,
          const Radius.circular(5.0),
        ),
        painter);

    canvas.drawPath(
        Path()
          ..addPolygon([
            Offset(isSelf ? size.width : 0.0, 10.0),
            Offset(isSelf ? size.width + 10.0 : -10.0, 15.0),
            Offset(isSelf ? size.width : 0.0, 20.0),
          ], true),
        painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
