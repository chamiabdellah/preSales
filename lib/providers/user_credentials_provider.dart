import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/User.dart';

import '../models/order.dart';

class UserCredentialsNotifier extends StateNotifier<User>{
  UserCredentialsNotifier() : super(User(userId: 'userId', name: 'name', email: 'email'));

  Future<void> saveData() async {
  }

  Future<void> getUserData(Order newOrder) async{
  }
}

final userCredentialsProvider = StateNotifierProvider<UserCredentialsNotifier, User>((ref){
  return UserCredentialsNotifier();
});