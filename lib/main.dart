import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/models/conversation.dart';
import 'package:gemsouls_chat_demo/models/message.dart';
import 'package:gemsouls_chat_demo/models/user.dart';
import 'package:gemsouls_chat_demo/pages/fake_login.dart';
import 'package:gemsouls_chat_demo/providers/conversation_provider.dart';
import 'package:gemsouls_chat_demo/providers/current_user_provider.dart';
import 'package:gemsouls_chat_demo/providers/users_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gemsouls_chat_demo/utils/path_provider_stub.dart';

late StateNotifierProvider<UsersProvider, List<User>> usersProvider;
final StateNotifierProvider<CurrentUserProvider, User?> currentUserProvider =
    StateNotifierProvider((ref) => CurrentUserProvider());

final StateNotifierProvider<ConversationProvider, Conversation?> conversationProvider =
    StateNotifierProvider((ref) => ConversationProvider());

Future main() async {
  var hivePath = await PathProviderImpl().getApplicationSupportDirectory();
  await Hive.initFlutter(hivePath);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ConversationAdapter());
  Hive.registerAdapter(MsgTypeAdapter());
  Hive.registerAdapter(MsgAdapter());

  UsersProvider _usersProvider = UsersProvider();
  await _usersProvider.init();

  usersProvider = StateNotifierProvider((ref) => _usersProvider);

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FakeLogin(),
    );
  }
}
