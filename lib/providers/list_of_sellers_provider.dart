import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/utils/SecurePath.dart';
import '../utils/Paths.dart';

class ListOfSellersNotifier extends StateNotifier<List<User>> {
  ListOfSellersNotifier() : super([]);

  Future<void> fetchSellers() async {
    String link = await SecurePath.appendToken(Paths.usersPath);
    Uri uri = Uri.parse(link);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<User> loadedUsers = [];
      extractedData.forEach((key, value) {
        loadedUsers.add(User(
          userId: key,
          name: value['name'] ?? '',
          email: value['email'] ?? '',
          profilePic: value['profilePic'] ?? '',
        ));
      });
      state = loadedUsers;
    } else {
      throw Exception("Erreur lors du chargement des vendeurs");
    }
  }
}

final listOfSellersProvider = StateNotifierProvider<ListOfSellersNotifier, List<User>>((ref) {
  return ListOfSellersNotifier();
});