import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/constant/app_constant.dart' show AppConstant;
import '../../utils/constant/user_constant.dart';

class ClassiaApiService {

  static  String authToken = "Bearer ${UserConstants.TOKEN}";

  // 📌 Get picked stock list
  Future<List<Map<String, dynamic>>> getPickedStockList({int limit = 10, int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstant.API_URL}/amc/picked/stock/list?limit=$limit&page=$page'),
        headers: {
          'Authorization': authToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final stocks = data['data']['stocks'] as List;
          return stocks.map((stock) => {
            'id': stock['ID'].toString(),
            'symbol': stock['Symbol'],
            'name': stock['Name'],
            'exchange': stock['Exchange'],
            'isin': stock['Isin'],
            'series': stock['Series'],
            'quantity': 1, // Default quantity
            'price': 0.0, // Will be updated by Alpha Vantage
          }).toList();
        }
      }

      print('Failed to load picked stocks: ${response.statusCode}');
      print('Response body: ${response.body}');
      return [];
    } catch (e) {
      print('Error fetching picked stocks: $e');
      return [];
    }
  }

  // 📌 Select/Unselect stock (pick/unpick)
  Future<bool> selectStock(String stockId, String action) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}/amc/select/stock'),
        headers: {
          'Authorization': authToken,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'stockId': stockId,
          'action': action, // 'pick' or 'unpick'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == true;
      }

      print('Failed to $action stock: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    } catch (e) {
      print('Error ${action}ing stock: $e');
      return false;
    }
  }

  // 📌 Pick a stock
  Future<bool> pickStock(String stockId) async {
    return await selectStock(stockId, 'pick');
  }

  // 📌 Unpick a stock
  Future<bool> unpickStock(String stockId) async {
    return await selectStock(stockId, 'unpick');
  }
}