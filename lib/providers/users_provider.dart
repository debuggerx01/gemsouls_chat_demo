import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemsouls_chat_demo/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UsersProvider extends StateNotifier<List<User>> {
  UsersProvider() : super([]);
  late Box<User> _userBox;

  Future init() async {
    _userBox = await Hive.openBox<User>('users');
    state.addAll(_userBox.values);
  }

  addUser() {
    var faker = Faker();
    int lastUid = _userBox.isEmpty ? -1 : (_userBox.keys.toList()..sort()).last;
    var user = User(
      uid: lastUid + 1,
      nickname: faker.person.lastName(),
      avatar: faker.image.image(keywords: ['avatar'], random: true),
    );
    _userBox.add(user);
    state = [...state, user];
  }
}
