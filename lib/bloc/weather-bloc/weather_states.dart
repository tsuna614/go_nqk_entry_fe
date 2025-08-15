import 'package:equatable/equatable.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';

abstract class WeatherStates extends Equatable {
  const WeatherStates();

  @override
  List<Object> get props => [];
}

class WeatherInitialState extends WeatherStates {}

class WeatherLoadingState
    extends WeatherStates {} // this is for initial loading

class WeatherLoadedState extends WeatherStates {
  final String city;
  final Weather currentWeather;
  final Map<int, List<Weather>> weatherMap;
  final int currentPage;
  final bool
  isLoadingMore; // this is for pagination, to show loading indicator when fetching more data

  // computed property to get the current 4 days weather list based on the current page
  List<Weather> get currentWeatherList {
    return weatherMap[currentPage] ?? [];
  }

  const WeatherLoadedState({
    required this.city,
    required this.currentWeather,
    required this.weatherMap,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  WeatherLoadedState copyWith({
    Weather? currentWeather,
    Map<int, List<Weather>>? weatherMap,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return WeatherLoadedState(
      city: city,
      currentWeather: currentWeather ?? this.currentWeather,
      weatherMap: weatherMap ?? this.weatherMap,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
    city,
    currentWeather,
    weatherMap,
    currentPage,
    isLoadingMore,
  ]; // THIS IS THE ANSWER TO THE QUESTION. IT IS USED TO COMPARE THE STATES AND CHECK IF THEY ARE EQUAL
}

class WeatherErrorState extends WeatherStates {
  final String message;

  const WeatherErrorState(this.message);

  @override
  List<Object> get props => [message];
}
