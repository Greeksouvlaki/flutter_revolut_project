import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://172.20.23.33:3306'; // WSL IP address

  Future<List<dynamic>> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transactions'));
      if (response.statusCode == 200) {
        print('Transactions fetched successfully');
        return json.decode(response.body);
      } else {
        print('Failed to load transactions. Status code: ${response.statusCode}');
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load transactions');
    }
  }

  Future<void> addTransaction(String description, double amount, String date) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'description': description,
          'amount': amount,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        print('Transaction added successfully');
      } else {
        print('Failed to add transaction. Status code: ${response.statusCode}');
        throw Exception('Failed to add transaction');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add transaction');
    }
  }
}
