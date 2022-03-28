import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/models/user.dart';

class CurrentUserProvider extends StateNotifier<User?> {
  CurrentUserProvider() : super(null);

  login(User user) {
    state = user;
  }

  User get currentUser => state!;
}
