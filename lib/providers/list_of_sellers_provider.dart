import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> addSeller({
    required String name,
    required String email,
    required String password,
    required String role,
    required File profileImage,
  }) async {
    String imageUrl = await _uploadProfileImage(profileImage, email);
    
    String link = await SecurePath.appendToken(Paths.usersPath);
    Uri uri = Uri.parse(link);
    
    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'profilePic': imageUrl,
    };
    
    final response = await http.post(uri, body: json.encode(requestBody));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final newUser = User(
        userId: extractedData['name'],
        name: name,
        email: email,
        profilePic: imageUrl,
      );
      state = [...state, newUser];
    } else {
      throw Exception("Erreur lors de l'ajout du vendeur");
    }
  }

  Future<String> _uploadProfileImage(File image, String email) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$email.jpeg');
    await storageRef.putFile(image);
    return storageRef.getDownloadURL();
  }
}

final listOfSellersProvider = StateNotifierProvider<ListOfSellersNotifier, List<User>>((ref) {
  return ListOfSellersNotifier();
});