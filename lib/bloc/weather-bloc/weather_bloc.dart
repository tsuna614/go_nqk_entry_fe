import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_events.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:go_nqk_entry_fe/services/weather_service.dart';

class WeatherBloc extends Bloc<WeatherEvents, WeatherStates> {
  final WeatherService weatherService;

  WeatherBloc({required this.weatherService}) : super(WeatherInitialState()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<ChangePageEvent>(_onChangePage);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherStates> emit,
  ) async {
    if (state is WeatherLoadedState &&
        (state as WeatherLoadedState).city.trim().toLowerCase() ==
            event.city.trim().toLowerCase()) {
      emit((state as WeatherLoadedState).copyWith(isLoadingMore: true));
    } else {
      emit(WeatherLoadingState());
    }

    // CASE 1: If that page is already loaded, just update the page
    if (state is WeatherLoadedState &&
        (state as WeatherLoadedState).weatherMap.containsKey(event.page)) {
      emit(
        (state as WeatherLoadedState).copyWith(
          currentPage: event.page,
          isLoadingMore: false,
        ),
      );
      // final loadedState = state as WeatherLoadedState;
      // emit(
      //   WeatherLoadedState(
      //     currentWeather: loadedState.currentWeather,
      //     weatherMap: loadedState.weatherMap,
      //     currentPage: event.page,
      //     isLoadingMore: false,
      //   ),
      // );
      return;
    }

    try {
      final response = await weatherService.getWeatherByPage(
        city: event.city,
        page: event.page,
      );

      if (response.statusCode == 200 && response.data != null) {
        final weatherList = response.data!;

        if (state is WeatherLoadedState) {
          // CASE 2: Load new data into the existing map, keeping currentWeather, only change the currentPage
          Map<int, List<Weather>> weatherMap =
              (state as WeatherLoadedState).weatherMap;
          weatherMap[event.page] = weatherList;

          emit(
            (state as WeatherLoadedState).copyWith(
              weatherMap: weatherMap,
              currentPage: event.page,
              isLoadingMore: false,
            ),
          );
        } else {
          // CASE 3: When first loaded, no previous data. currentPage is 0 and currentWeather is set to the first item
          Map<int, List<Weather>> weatherMap = {};
          weatherMap[event.page] = weatherList;

          emit(
            WeatherLoadedState(
              city: event.city,
              currentWeather: weatherList.first,
              weatherMap: weatherMap,
              currentPage: event.page,
            ),
          );
        }
      } else {
        print('Error fetching weather data');
        emit(WeatherErrorState("Failed to fetch weather data"));
      }
    } catch (e) {
      print('Exception occurred: $e');
      emit(WeatherErrorState("An error occurred while fetching weather data"));
    }
  }

  void _onChangePage(ChangePageEvent event, Emitter<WeatherStates> emit) async {
    if (state is WeatherLoadedState) {
      // final loadedState = state as WeatherLoadedState;
      // emit(
      //   WeatherLoadedState(
      //     city: loadedState.city,
      //     currentWeather: loadedState.weatherMap[event.page]!.first,
      //     weatherMap: loadedState.weatherMap,
      //     currentPage: event.page,
      //   ),
      // );
      emit((state as WeatherLoadedState).copyWith(currentPage: event.page));
    }
  }
}
