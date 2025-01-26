import '../services/SecureStorageService.dart';

class SecurePath {

  static Future<String> appendToken(String path) async {
    final token = await SecureStorageService().getJwtToken();
    if(path.contains("?")){
      return '$path&auth=$token';
    }
    return '$path?auth=$token';
  }
}
