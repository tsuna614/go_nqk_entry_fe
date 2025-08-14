import 'package:equatable/equatable.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';

abstract class WeatherStates extends Equatable {
  const WeatherStates();

  @override
  List<Object> get props => [];
}

class WeatherInitialState extends WeatherStates {}

class WeatherLoadingState extends WeatherStates {}

class WeatherLoadedState extends WeatherStates {
  final Weather currentWeather;
  final Map<int, List<Weather>> weatherMap;
  final int currentPage;

  // computed property to get the current 4 days weather list based on the current page
  List<Weather> get currentWeatherList {
    return weatherMap[currentPage] ?? [];
  }

  const WeatherLoadedState({
    required this.currentWeather,
    required this.weatherMap,
    required this.currentPage,
  });

  // WeatherLoadedState copyWith({
  //   Weather? currentWeather,
  //   List<Weather>? weatherList,
  //   int? currentPage,
  // }) {
  //   return WeatherLoadedState(
  //     currentWeather: currentWeather ?? this.currentWeather,
  //     weatherList: weatherList ?? this.weatherList,
  //     currentPage: currentPage ?? this.currentPage,
  //   );
  // }

  // @override
  // List<Object> get props => [weatherList, currentWeather];
}

class WeatherErrorState extends WeatherStates {
  final String message;

  const WeatherErrorState(this.message);

  @override
  List<Object> get props => [message];
}
