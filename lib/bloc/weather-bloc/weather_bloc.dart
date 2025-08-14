import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_events.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
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

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final weatherList = response.data!;

        if (state is WeatherLoadedState) {
          // if the state is already loaded, keep the old currentWeather
          final current = (state as WeatherLoadedState).currentWeather;
          // update the weatherMap with the new weatherList
          Map<int, List<Weather>> weatherMap =
              (state as WeatherLoadedState).weatherMap;
          weatherMap[event.page] = weatherList;

          emit(
            WeatherLoadedState(
              currentWeather: current,
              weatherMap: weatherMap,
              currentPage: event.page,
            ),
          );
        } else {
          // if the state is not loaded (first time fetching), set the first item as currentWeather
          // (because page = 0 so the first item is the current date)
          Map<int, List<Weather>> weatherMap = {};
          weatherMap[event.page] = weatherList;

          emit(
            WeatherLoadedState(
              currentWeather: weatherList.first,
              weatherMap: weatherMap,
              currentPage: event.page,
            ),
          );
        }
      } else {
        print('Error fetching weather data');
        emit(WeatherInitialState());
      }
    } catch (e) {
      print('Exception occurred: $e');
      emit(WeatherInitialState());
    }
  }
}
