import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/constant/app_constant.dart';
import '../../utils/constant/user_constant.dart';

class BasketApiService {
  final String _base = AppConstant.NODE_API_URL;

  /// Fetch list of baskets with optional filters
  Future<Map<String, dynamic>> fetchBaskets({
    String? subscriptionType,
    String? volatility,
    String? status = 'ACTIVE',
    String? type,
    int? id,
    int page = 1,
    int sizePerPage = 50,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    // Build query parameters dynamically
    final queryParams = <String, String>{
      'page': page.toString(),
      'sizePerPage': sizePerPage.toString(),
    };

    if (subscriptionType != null && subscriptionType != 'ALL') {
      queryParams['subscryptionType'] = subscriptionType;
    }
    if (volatility != null && volatility != 'ALL') {
      queryParams['volatility'] = volatility;
    }
    if (status != null) {
      queryParams['status'] = status;
    }
    if (type != null && type != 'ALL') {
      queryParams['type'] = type;
    }
    if (id != null) {
      queryParams['id'] = id.toString();
    }

    final uri = Uri.parse('$_base/basket/list').replace(queryParameters: queryParams);

    final resp = await http.get(uri, headers: {'Authorization': token});
    if (resp.statusCode != 200) {
      throw Exception('Failed to load baskets: ${resp.body}');
    }
    return jsonDecode(resp.body);
  }

  /// Create a new basket
  Future<Map<String, dynamic>> createBasket({
    required String basketName,
    required String subscriptionAmount,
    required String raName,
    required String expectedReturn,
    required String subscriptionType,
    required String volatility,
    required String status,
    required String type,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final resp = await http.post(
      Uri.parse('$_base/basket/create'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'basketName': basketName,
        'subscriptionAmount': subscriptionAmount,
        'raName': raName,
        'expectedReturn': expectedReturn,
        'subscryptionType': subscriptionType,
        'volatility': volatility,
        'status': status,
        'type': type,
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Create basket failed: ${resp.body}');
    }
    return jsonDecode(resp.body);
  }

  /// Update existing basket
  Future<Map<String, dynamic>> updateBasket({
    required int basketId,
    required String basketName,
    required String subscriptionAmount,
    required String raName,
    required String expectedReturn,
    required String subscriptionType,
    required String volatility,
    required String status,
    required String type,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final resp = await http.put(
      Uri.parse('$_base/basket/update'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'basketId': basketId.toString(),
        'basketName': basketName,
        'subscriptionAmount': subscriptionAmount,
        'raName': raName,
        'expectedReturn': expectedReturn,
        'subscryptionType': subscriptionType,
        'volatility': volatility,
        'status': status,
        'type': type,
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Update basket failed: ${resp.body}');
    }
    return jsonDecode(resp.body);
  }

  /// Add stock to basket
  Future<void> addStock({
    required int basketId,
    required int stockId,
    required String holdinPercentage,
    required String slPrice,
    required String tgtPrice,
    required String orderType,
    required String quantity,
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
        'quantity': quantity,
      },
    );

    if (resp.statusCode != 200) {
      throw Exception('Add stock failed: ${resp.body}');
    }
  }

  /// Remove stock from basket
  Future<void> removeStock({
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

    if (resp.statusCode != 200) {
      throw Exception('Remove stock failed: ${resp.body}');
    }
  }

  /// Fetch reviews for a specific basket
  Future<List<dynamic>> fetchReviews({
    required int basketId,
    int? reviewId,
    String search = '',
    int page = 1,
    int limit = 20,
  }) async {
    final token = UserConstants.TOKEN;
    if (token == null) throw Exception('No auth token');

    final queryParams = <String, String>{
      'basketId': basketId.toString(),
      'page': page.toString(),
    
    };

    if (reviewId != null) {
      queryParams['reviewId'] = reviewId.toString();
    }
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final uri = Uri.parse('$_base/basket/review/list').replace(queryParameters: queryParams);

    final resp = await http.get(uri, headers: {'Authorization': token});

    if (resp.statusCode != 200) {
      throw Exception('Failed to load reviews: ${resp.body}');
    }

    final json = jsonDecode(resp.body);
    return json['data']['reviewList'] as List<dynamic>? ?? [];
  }
}