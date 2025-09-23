import 'package:restoguh_dicoding_fundamentl/models/restaurant_detail.dart';

sealed class RestoguhDetailResultState {}

class RestoguhDetailNoneState extends RestoguhDetailResultState {}

class RestoguhDetailLoadingState extends RestoguhDetailResultState {}

class RestoguhDetailErrorState extends RestoguhDetailResultState {
  final String error;

  RestoguhDetailErrorState(this.error);
}

class RestoguhDetailLoadedState extends RestoguhDetailResultState {
  final RestaurantDetail restaurant;

  RestoguhDetailLoadedState(this.restaurant);
}
