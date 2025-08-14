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
  final List<Weather> weatherList;

  const WeatherLoadedState({required this.weatherList});

  WeatherLoadedState copyWith({List<Weather>? weatherList}) {
    return WeatherLoadedState(weatherList: weatherList ?? this.weatherList);
  }

  @override
  List<Object> get props => [weatherList];
}
