import 'dart:convert';
import 'package:http/http.dart' as http;

class AlphaVantageService {
  final List<String> apiKeys = [
    'TS11J279BPAJ8L9G',
    'AHU75034GIKJ0YSD',
    'U13A8HHFE4PB5XNB',
    'WHH8Y5YRVHPOV2A0',
    'GASE60SOROPBA7E5',
  ];

  int _apiCallCount = 0;
  int _currentApiIndex = 0;

  // Fetch real-time stock price
  Future<double> getStockPrice(String symbol) async {
    _updateApiKey(); // Check if API key needs to be switched

    final String apiKey = apiKeys[_currentApiIndex];
    print('apikey $apiKey');
    final url = Uri.parse(
      'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey',
    );

    try {
      final response = await http.get(url);
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('Global Quote') && data['Global Quote'].containsKey('05. price')) {
          return double.parse(data['Global Quote']['05. price']);
        } else {
          print("Invalid response format: $data");
          return 2004.4; // Default value for testing
        }
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
        return 4545.0; // Dummy value for testing
      }
    } catch (e) {
      print("Error: $e");
      return 0.0; // Default value in case of an error
    }
  }

  // 📌 Update API key after 24 calls
  void _updateApiKey() {
    _apiCallCount++;

    if (_apiCallCount >= 24) {
      _apiCallCount = 0; // Reset call count
      _currentApiIndex = (_currentApiIndex + 1) % apiKeys.length; // Rotate API key
      print("🔄 Switching to new API Key: ${apiKeys[_currentApiIndex]}");
    }
  }
}
