import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/constant/user_constant.dart';

class MarketApiService {
  static const String _baseUrl = 'https://api.classiacapital.com';

  // Fetch stock data from API
  Future<List<Map<String, dynamic>>> fetchStockData(int page, int limit) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token found');

    final response = await http.get(
      Uri.parse('$_baseUrl/amc/stock/list?page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']['stocks']);
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  // Toggle stock selection/unselection
  Future<void> toggleStockSelection(String stockId, bool isSelected) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token found');

    final action = isSelected ? 'unpick' : 'pick';
    final response = await http.post(
      Uri.parse('$_baseUrl/amc/select/stock'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'stockId': stockId,
        'action': action,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle stock selection');
    }
  }
}