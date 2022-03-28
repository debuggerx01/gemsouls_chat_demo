import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/extensions.dart';
import 'package:gemsouls_chat_demo/main.dart';
import 'package:gemsouls_chat_demo/pages/chat.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(conversationProvider);
    var _currentUser = ref.read(currentUserProvider.notifier).currentUser;
    var _conversationProvider = ref.read(conversationProvider.notifier);
    var _userList = ref.read(usersProvider).where((user) => user.uid != _currentUser.uid).toList();
    _userList.sort((a, b) {
      var conversationA =
          _conversationProvider.getConversationByToUid(a.uid)?.lastMsg?.timestamp.millisecondsSinceEpoch ?? 0;
      var conversationB =
          _conversationProvider.getConversationByToUid(b.uid)?.lastMsg?.timestamp.millisecondsSinceEpoch ?? 0;
      return conversationB - conversationA;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(_currentUser.avatar!),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (context, index) {
            var _user = _userList[index];
            var conversation = _conversationProvider.getConversationByToUid(_user.uid);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                await _conversationProvider.startConversation(_user, conversation == null);
                context.n
                    .push(
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                )
                    .then((_) {
                  _conversationProvider.stopConversation();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(_user.avatar!),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_user.nickname),
                        Text(
                          conversation?.lastMsg?.displayMsg ?? '',
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    conversation?.lastMsg?.timestamp == null
                        ? ''
                        : formatDate(
                            conversation!.lastMsg!.timestamp,
                            [mm, '/', dd, ' ', HH, ':', nn, ':', ss],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: FloatingActionButton(
          onPressed: context.n.pop,
          tooltip: 'Logout',
          child: Transform.rotate(
            angle: pi,
            child: const Icon(Icons.logout),
          ),
        ),
      ),
    );
  }
}
