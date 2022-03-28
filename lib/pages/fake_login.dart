import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/extensions.dart';
import 'package:gemsouls_chat_demo/main.dart';
import 'package:gemsouls_chat_demo/pages/contacts.dart';

class FakeLogin extends ConsumerWidget {
  const FakeLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Login - click a avatar to login'),
      ),
      body: Wrap(
        children: ref
            .watch(usersProvider)
            .map(
              (e) => GestureDetector(
                onTap: () async {
                  ref.read(currentUserProvider.notifier).login(e);
                  await ref.read(conversationProvider.notifier).loadByFromUid(e.uid);
                  context.n.push(MaterialPageRoute(
                    builder: (context) => const ContactsPage(),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        foregroundImage: e.avatar == null
                            ? null
                            : CachedNetworkImageProvider(
                                e.avatar!,
                              ),
                      ),
                      Text(e.nickname),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: FloatingActionButton(
          onPressed: ref.read(usersProvider.notifier).addUser,
          tooltip: 'Add user',
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}
