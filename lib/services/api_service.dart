import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/foundation.dart';

class ApiService {
  late final http.Client _client;
  static const base = 'https://restaurant-api.dicoding.dev';

  static Future<List<Restaurant>> fetchRestaurants() async {
    final resp = await http.get(Uri.parse('$base/list'));
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);
      final list = jsonBody['restaurants'] as List;
      return list.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  static Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final resp = await http.get(Uri.parse('$base/detail/$id'));
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);
      return RestaurantDetail.fromJson(jsonBody);
    } else {
      throw Exception('Failed to fetch detail');
    }
  }

  static Future<List<Restaurant>> searchRestaurants(String query) async {
    final resp = await http.get(
      Uri.parse('$base/search?q=${Uri.encodeQueryComponent(query)}'),
    );
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);
      final list = jsonBody['restaurants'] as List;
      return list.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception('Search failed');
    }
  }

  static Future<bool> postReview(String id, String name, String review) async {
    final resp = await http.post(
      Uri.parse('$base/review'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'name': name, 'review': review}),
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);
      return jsonBody['customerReviews'] != null;
    } else {
      throw Exception('Failed to post review');
    }
  }

  static String imageUrl(String pictureId) {
    return 'https://restaurant-api.dicoding.dev/images/large/$pictureId';
  }

  // add review
  static Future<bool> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse("$base/review"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name, "review": review}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Failed: ${response.body}");
      return false;
    }
  }

  Future<Uint8List> getByteArrayFromUrl(String url) async {
    final response = await _client.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<String> downloadAndSaveFile(String url, String fileName) async {
    final bytes = await getByteArrayFromUrl(url);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
