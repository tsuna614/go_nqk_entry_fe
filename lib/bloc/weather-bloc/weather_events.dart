abstract class WeatherEvents {
  const WeatherEvents();

  List<Object?> get props => [];
}

class FetchWeatherEvent extends WeatherEvents {
  final String city;
  final int page;

  FetchWeatherEvent({required this.city, required this.page});

  @override
  List<Object?> get props => [city, page];
}
