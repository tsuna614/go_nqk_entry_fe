import 'package:flutter/material.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:intl/intl.dart';

class HorizontalForecastCards extends StatefulWidget {
  final WeatherStates state;
  const HorizontalForecastCards({super.key, required this.state});

  @override
  State<HorizontalForecastCards> createState() =>
      _HorizontalForecastCardsState();
}

class _HorizontalForecastCardsState extends State<HorizontalForecastCards> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.state is WeatherLoadingState)
              ...List.generate(4, (index) => buildShimmerForecastCard())
            else if (widget.state is WeatherLoadedState)
              ...((widget.state as WeatherLoadedState).currentWeatherList.map(
                (weather) => buildForecastCard(weather),
              ))
            else
              const Center(child: Text('No weather data available')),
            // for (var weather in dummyWeatherData) forecastCard(weather),
          ],
        ),
      ),
    );
  }

  Widget buildForecastCard(Weather weather) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatter.format(weather.dateTime),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Icon(weather.icon, color: Colors.white, size: 32),
          Image.network(
            'https:${weather.iconUrl}',
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.white);
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Temp: ${weather.temperature}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Wind: ${weather.windSpeed}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Humidity: ${weather.humidity}%',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildShimmerForecastCard() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 16, width: 80, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Container(height: 32, width: 32, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Container(height: 16, width: 100, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Container(height: 16, width: 100, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Container(height: 16, width: 100, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
