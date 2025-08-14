import 'package:flutter/material.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:intl/intl.dart';

class MainForecastCard extends StatelessWidget {
  final WeatherStates state;
  const MainForecastCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is WeatherLoadingState) {
      return buildForecastCardShimmer();
    } else if (state is WeatherLoadedState) {
      final weatherData = (state as WeatherLoadedState).currentWeather;
      return buildForecastCard(weatherData);
    } else {
      return const Center(child: Text('No weather data available'));
    }
  }

  Widget buildForecastCard(Weather weatherData) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7BE4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weatherData.cityName} (${formatter.format(weatherData.dateTime)})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                'Temperature: ${weatherData.temperature}°C',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Wind: ${weatherData.windSpeed} M/S',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Humidity: ${weatherData.humidity}%',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            children: [
              // Icon(weatherData.icon, color: Colors.white, size: 48),
              Image.network(
                'https:${weatherData.iconUrl}',
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.white);
                },
              ),
              const SizedBox(height: 4),
              Text(
                weatherData.condition,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildForecastCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 150, height: 20, color: Colors.grey[400]),
              const SizedBox(height: 13),
              Container(width: 100, height: 15, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Container(width: 80, height: 15, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Container(width: 70, height: 15, color: Colors.grey[400]),
            ],
          ),
          Column(
            children: [
              Container(width: 48, height: 48, color: Colors.grey[400]),
              const SizedBox(height: 4),
              Container(width: 60, height: 15, color: Colors.grey[400]),
            ],
          ),
        ],
      ),
    );
  }
}
