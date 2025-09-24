import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proj1/models/User.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save credentials securely
  Future<void> saveCredentials(String email, String token, String? role) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'token', value: token);
    if(role != null){
      await _storage.write(key: 'role', value: role);
    }
  }

  // Save password securely
  Future<void> savePassword(String password) async {
    await _storage.write(key: 'password', value: password);
  }

  // Get saved password
  Future<String?> getPassword() async {
    return await _storage.read(key: 'password');
  }

  // Retrieve credentials securely
  Future<Map<String, String?>> getCredentials() async {
    String? email = await _storage.read(key: 'email');
    String? token = await _storage.read(key: 'token');
    String? role = await _storage.read(key: 'role');
    return {'email': email, 'token': token, 'role': role};
  }

  Future<String?> getJwtToken() async {
    String? token = await _storage.read(key: 'token');
    return token;
  }

  Future<UserRole> getUserRole() async {
    String? role = await _storage.read(key: 'role');
    return UserRole.values.firstWhere((e) => e.toString() == role, orElse: () => UserRole.unknown);
  }

  // Delete credentials
  Future<void> deleteCredentials() async {
    await _storage.deleteAll();
  }
}
