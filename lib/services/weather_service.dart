import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:go_nqk_entry_fe/services/api_client.dart';

abstract class WeatherService {
  Future<ApiResponse<Weather>> getWeather({
    required String city,
    DateTime? date,
  });

  Future<ApiResponse<List<Weather>>> getWeatherInRange({
    required String city,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<ApiResponse<List<Weather>>> getWeatherByPage({
    required String city,
    required int page,
  });
}

class WeatherServiceImpl implements WeatherService {
  final ApiClient apiClient;

  WeatherServiceImpl(this.apiClient);

  @override
  Future<ApiResponse<Weather>> getWeather({
    required String city,
    DateTime? date,
  }) {
    final endpoint = '/weather/getWeather';
    return apiClient.get(
      endpoint: endpoint,
      queryParameters: {
        'city': city,
        if (date != null) 'date': date.toIso8601String(),
      },
      fromJson: (data) => Weather.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<List<Weather>>> getWeatherInRange({
    required String city,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final endpoint = '/weather/getWeatherInRange';
    return apiClient.get(
      endpoint: endpoint,
      queryParameters: {
        'city': city,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
      fromJson: (data) => (data as List)
          .map((item) => Weather.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<List<Weather>>> getWeatherByPage({
    required String city,
    required int page,
  }) {
    final endpoint = '/weather/getWeatherByPage';
    return apiClient.get(
      endpoint: endpoint,
      queryParameters: {'city': city, 'page': page},
      fromJson: (data) => (data as List)
          .map((item) => Weather.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
