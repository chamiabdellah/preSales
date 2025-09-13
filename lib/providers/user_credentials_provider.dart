import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/utils/SecurePath.dart';
import '../utils/Paths.dart';

class UserCredentialsNotifier extends StateNotifier<User?>{
  UserCredentialsNotifier() : super(null);

  Future<void> fetchUserById(String userId) async {
    try {
      String link = await SecurePath.appendToken('${Paths.usersPath.replaceAll('.json', '')}/$userId.json');
      Uri uri = Uri.parse(link);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final userData = json.decode(response.body) as Map<String, dynamic>;
        print(userData);
        state = User(
          userId: userId,
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          profilePic: userData['profilePic'] ?? '',
        );
      } else {
        throw Exception('Utilisateur non trouvé');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des données utilisateur: $e');
    }
  }

  void clearUser() {
    state = null;
  }
}

final userCredentialsProvider = StateNotifierProvider<UserCredentialsNotifier, User?>((ref){
  return UserCredentialsNotifier();
});