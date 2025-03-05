// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class AlphaVantageService {
//   final String _apiKey = 'WHH8Y5YRVHPOV2A0';
//
//   // Fetch real-time stock price
//   Future<double> getStockPrice(String symbol) async {
//     final url = Uri.parse(
//       'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
//     );
//
//     try {
//       final response = await http.get(url);
//         print(response.statusCode);
//         print(response.body);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final price = double.parse(data['Global Quote']['05. price']);
//         return price;
//       } else {
//         final price = 4545;
//         return  double.parse(price) ;
//       }
//     } catch (e) {
//         throw Exception('Error fetching stock price: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class AlphaVantageService {
  final String _apiKey = 'WHH8Y5YRVHPOV2A0';

  // Fetch real-time stock price
  Future<double> getStockPrice(String symbol) async {
    final url = Uri.parse(
      'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
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
          return 122.4; // Return a default value for testing
        }
      } else {
        print("Failed to fetch data. Status Code: ${response.statusCode}");
        return 4545.0; // Return a dummy value for testing
      }
    } catch (e) {
      print("Error: $e");
      return 0.0; // Return a default value in case of an error
    }
  }
}
