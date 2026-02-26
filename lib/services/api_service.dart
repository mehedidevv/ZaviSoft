// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  /// Login and return token
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
      print(response.body);
      final data = jsonDecode(response.body);
      return data['token'];
    }
    throw Exception('Login failed: ${response.body}');
  }

  /// Fetch user profile by userId
  static Future<UserModel> getUser(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load user');
  }

  /// Fetch all products
  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  /// Fetch products by category
  static Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load products by category');
  }

  /// Fetch all categories
  static Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/products/categories'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<String>();
    }
    throw Exception('Failed to load categories');
  }
}
