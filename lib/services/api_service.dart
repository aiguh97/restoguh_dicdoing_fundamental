import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  /// Ambil daftar semua restoran
  Future<List<Restaurant>> fetchRestaurants() async {
    final response = await _client.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List restaurants = data['restaurants'];
      return restaurants.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  /// Cari restoran berdasarkan query
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final response = await _client.get(Uri.parse("$_baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List restaurants = data['restaurants'];
      return restaurants.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception("Failed to search restaurants");
    }
  }

  /// Ambil detail restoran berdasarkan ID
  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final response = await _client.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return RestaurantDetail.fromJson(data);
    } else {
      throw Exception("Failed to fetch restaurant detail");
    }
  }

  /// Kirim ulasan restoran
  Future<bool> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await _client.post(
      Uri.parse("$_baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name, "review": review}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['customerReviews'] != null;
    } else {
      throw Exception("Failed to post review");
    }
  }

  /// Ambil byte array dari URL
  Future<Uint8List> getByteArrayFromUrl(String url) async {
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to download bytes from $url");
    }
  }

  /// Download file dan simpan ke local storage
  Future<String> downloadAndSaveFile(String url, String fileName) async {
    final bytes = await getByteArrayFromUrl(url);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final File file = File(filePath);

    await file.writeAsBytes(bytes);
    return filePath;
  }

  /// Helper untuk ambil URL gambar
  static String imageUrl(String pictureId) {
    return '$_baseUrl/images/large/$pictureId';
  }
}
