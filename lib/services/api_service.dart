import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_app/models/product.dart';

part 'api_service.g.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}

@riverpod
ApiService apiService(Ref ref) { 
  return ApiService();
}