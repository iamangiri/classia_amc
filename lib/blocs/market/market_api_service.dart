import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/constant/app_constant.dart';
import '../../utils/constant/user_constant.dart';

class MarketApiService {
  final String _base = AppConstant.NODE_API_URL;

  // Fetch all stocks
  Future<List<Map<String, dynamic>>> fetchStocks({
    int page = 1,
    int limit = 50,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final uri = Uri.parse('$_base/basket/stocks-list?page=$page');
    final resp = await http.get(uri, headers: {'Authorization': token});

    if (resp.statusCode != 200) throw Exception('Failed to load stocks');

    final json = jsonDecode(resp.body);
    final stocksList = json['data']['stocksList'] as List<dynamic>?;
    
    if (stocksList == null) return [];
    
    return stocksList.map((item) => item as Map<String, dynamic>).toList();
  }

  // Fetch all baskets
  Future<Map<String, dynamic>> fetchBaskets() async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final uri = Uri.parse(
        '$_base/basket/list?subscryptionType=FREE&volatility=LOW&status=ACTIVE&page=1&sizePerPage=50');

    final resp = await http.get(uri, headers: {'Authorization': token});
    if (resp.statusCode != 200) throw Exception('Failed to load baskets');

    return jsonDecode(resp.body);
  }

  // Add stock to basket
  Future<void> addStockToBasket({
    required int basketId,
    required int stockId,
    required String holdinPercentage,
    required String slPrice,
    required String tgtPrice,
    required String orderType,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final resp = await http.post(
      Uri.parse('$_base/basket/add-stocks'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'basketId': basketId.toString(),
        'stockId': stockId.toString(),
        'holdinPercentage': holdinPercentage,
        'slPrice': slPrice,
        'tgtPrice': tgtPrice,
        'orderType': orderType,
      },
    );

    if (resp.statusCode != 200) throw Exception('Add stock failed');
  }

  // Remove stock from basket
  Future<void> removeStockFromBasket({
    required int basketId,
    required int stockId,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final resp = await http.post(
      Uri.parse('$_base/basket/remove-stocks'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'basketId': basketId.toString(),
        'stockId': stockId.toString(),
      },
    );

    if (resp.statusCode != 200) throw Exception('Remove stock failed');
  }
}