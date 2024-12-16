import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  final String apiKey = '9dfb2a723559fe98b783e09d';

  Future<Map<String, dynamic>> fetchCurrencies() async {
    final response = await http.get(
      Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/USD'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['conversion_rates'];
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  Future<Map<String, dynamic>> fetchRateAndTime(String fromCurrency) async {
    final response = await http.get(
      Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/$fromCurrency'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load rate and time');
    }
  }
}
