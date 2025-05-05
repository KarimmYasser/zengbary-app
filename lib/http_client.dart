import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static String baseUrl =
      'http://localhost:8080'; // Replace with your API base URL
  static DateTime? _lastRequestTime;

  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    _throttleRequests();
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic data,
  ) async {
    _throttleRequests();
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    _throttleRequests();
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    _throttleRequests();
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Throttle requests to ensure at least 1 second between requests
  static void _throttleRequests() {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest.inMilliseconds < 1000) {
        throw Exception(
          'Too many requests. Please wait before making another request.',
        );
      }
    }
    _lastRequestTime = DateTime.now();
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
