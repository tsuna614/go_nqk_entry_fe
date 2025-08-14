import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_events.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/services/weather_service.dart';

class WeatherBloc extends Bloc<WeatherEvents, WeatherStates> {
  final WeatherService weatherService;

  WeatherBloc({required this.weatherService}) : super(WeatherInitialState()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherStates> emit,
  ) async {
    emit(WeatherLoadingState());
    try {
      final response = await weatherService.getWeatherByPage(
        city: event.city,
        page: event.page,
      );

      if (response.statusCode == 200 && response.data != null) {
        emit(WeatherLoadedState(weatherList: response.data!));
      } else {
        emit(WeatherInitialState());
      }
    } catch (e) {
      emit(WeatherInitialState());
    }
  }
}
