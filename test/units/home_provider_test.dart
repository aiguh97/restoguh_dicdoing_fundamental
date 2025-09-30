// test/home_provider_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:restoguh_dicoding_fundamentl/providers/home_provider.dart';
import 'package:restoguh_dicoding_fundamentl/services/api_service.dart';
import 'package:restoguh_dicoding_fundamentl/static/restoguh_list_result_state.dart';

void main() {
  group('HomeProvider', () {
    test('State awal harus None', () {
      final provider = HomeProvider();
      expect(provider.state, isA<RestoguhListNoneState>());
    });

    test('Berhasil ambil daftar restoran dari API', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
            jsonEncode({
              "error": false,
              "message": "success",
              "count": 1,
              "restaurants": [
                {
                  "id": "1",
                  "name": "Restoran Enak",
                  "description": "Mantap",
                  "pictureId": "14",
                  "city": "Jakarta",
                  "rating": 4.5
                }
              ]
            }),
            200);
      });

      final api = ApiService();
      final provider = HomeProvider(apiService: api);

      await provider.fetchRestaurants();

      expect(provider.state, isA<RestoguhListLoadedState>());
      final state = provider.state as RestoguhListLoadedState;
      expect(state.data.length, 1);
      expect(state.data.first.name, "Restoran Enak");
    });

    test('Gagal ambil data restoran dari API', () async {
      final mockClient = MockClient((request) async {
        return http.Response("Server Error", 500);
      });

      final api = ApiService();
      final provider = HomeProvider(apiService: api);

      await provider.fetchRestaurants();

      expect(provider.state, isA<RestoguhListErrorState>());
      final state = provider.state as RestoguhListErrorState;
      expect(state.error, contains("Koneksi Terputus"));
    });
  });
}
