import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('https://api.classiacapital.com/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
      },
    );
      print(response.body);
      print(response.statusCode);
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': responseData,
      };
    } else {
      return {
        'success': false,
        'message': responseData['message'] ?? 'Login failed',
      };
    }
  }
}
