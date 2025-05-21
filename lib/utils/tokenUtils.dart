import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic>? decodeToken(String token) {
  bool isExpired = JwtDecoder.isExpired(token);

  if (isExpired) {
    print("Token telah kedaluwarsa");
    return null;
  }

  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

  return {
    'id': decodedToken['id'],
    'email': decodedToken['email'],
    'role': decodedToken['role'],
  };
}

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}
