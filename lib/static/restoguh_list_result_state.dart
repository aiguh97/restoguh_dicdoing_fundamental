import 'package:restoguh_dicoding_fundamentl/models/restaurant.dart';

sealed class RestoguhListResultState {}

class RestoguhListNoneState extends RestoguhListResultState {}

class RestoguhListLoadingState extends RestoguhListResultState {}

class RestoguhListErrorState extends RestoguhListResultState {
  final String error;
  RestoguhListErrorState(this.error);
}

class RestoguhListLoadedState extends RestoguhListResultState {
  final List<Restaurant> data;
  final String query; // tambahan untuk tahu ini hasil search atau bukan
  RestoguhListLoadedState(this.data, {this.query = ""});
}
