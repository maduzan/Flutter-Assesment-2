import 'package:dio/dio.dart';
import 'package:sample/product.dart';
import 'dart:async';

class ApiService {
  static const String url = 'https://dummyjson.com/products';
  static final Dio _dio = Dio();

  static Stream<List<Product>> streamProducts() async* {
    try {
      while (true) {
        final response = await _dio.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['products'];
          yield data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load products');
        }

        await Future.delayed(Duration(seconds: 10));
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<Product> fetchProduct(int id) async {
    try {
      final response = await _dio.get('$url/$id');

      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }
}
