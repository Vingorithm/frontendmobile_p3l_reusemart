import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}