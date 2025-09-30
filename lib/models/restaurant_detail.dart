import 'package:restoguh_dicoding_fundamentl/models/restaurant.dart';

class Category {
  final String name;
  Category({required this.name});
  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name']);
}

class MenuItem {
  final String name;
  MenuItem({required this.name});
  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      MenuItem(name: json['name']);
}

class CustomerReview {
  final String name;
  final String review;
  final String date;
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });
  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json['name'],
    review: json['review'],
    date: json['date'],
  );
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final List<Category> categories;
  final List<MenuItem> foods;
  final List<MenuItem> drinks;
  final double rating;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.categories,
    required this.foods,
    required this.drinks,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final r = json['restaurant'];
    return RestaurantDetail(
      id: r['id'],
      name: r['name'],
      description: r['description'] ?? '',
      pictureId: r['pictureId'] ?? '',
      city: r['city'] ?? '',
      address: r['address'] ?? '',
      categories: (r['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
      foods: (r['menus']['foods'] as List)
          .map((e) => MenuItem.fromJson(e))
          .toList(),
      drinks: (r['menus']['drinks'] as List)
          .map((e) => MenuItem.fromJson(e))
          .toList(),
      rating: (r['rating'] is int)
          ? (r['rating'] as int).toDouble()
          : (r['rating'] as num).toDouble(),
      customerReviews: (r['customerReviews'] as List)
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}

extension RestaurantDetailX on RestaurantDetail {
  Restaurant toRestaurant() {
    return Restaurant(
      id: this.id,
      name: this.name,
      description: this.description,
      pictureId: this.pictureId,
      city: this.city,
      rating: this.rating,
    );
  }
}
