// lib/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'product.dart';

class ApiService {
  // Chọn base URL theo nền tảng chạy app.
  // - Web: dùng localhost (truy cập trình duyệt máy tính)
  // - Android emulator: 10.0.2.2
  // - iOS simulator: 127.0.0.1
  // - Thiết bị thật: thay bằng IP LAN máy tính, ví dụ: http://192.168.1.10:8000/api
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
      if (Platform.isIOS) return 'http://127.0.0.1:8000/api';
    } catch (_) {
      // Platform not available (e.g., tests). Fallback to localhost.
    }
    return 'http://127.0.0.1:8000/api';
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Product> products = body
          .map(
            (dynamic item) => Product.fromJson(item),
          )
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct({
    required String name,
    String? description,
    required String price,
  }) async {
    final uri = Uri.parse('$baseUrl/products');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Product.fromJson(data);
    }

    if (response.statusCode == 422) {
      // Laravel validation error format: { message: string, errors: { field: [msgs] } }
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      final String friendlyMessage = _extractValidationMessage(errorBody);
      throw ValidationException(message: friendlyMessage, details: errorBody);
    }

    throw Exception('Failed to create product (status ${response.statusCode})');
  }

  Future<void> deleteProduct(int id) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    final response = await http.delete(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      return;
    }

    if (response.statusCode == 404) {
      throw Exception('Sản phẩm không tồn tại');
    }

    throw Exception('Xóa sản phẩm thất bại (status ${response.statusCode})');
  }
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? details;

  ValidationException({required this.message, this.details});

  @override
  String toString() => message;
}

String _extractValidationMessage(Map<String, dynamic> errorBody) {
  try {
    // Prefer the first validation error message if present
    if (errorBody['errors'] is Map<String, dynamic>) {
      final Map<String, dynamic> errors = errorBody['errors'] as Map<String, dynamic>;
      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        } else if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }
    if (errorBody['message'] is String && (errorBody['message'] as String).isNotEmpty) {
      return errorBody['message'] as String;
    }
  } catch (_) {
    // fall through
  }
  return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra và thử lại.';
}
