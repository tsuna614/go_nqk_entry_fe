import 'package:flutter/material.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherPanel extends StatelessWidget {
  const WeatherPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The main big forecast card
        mainForecastCard(dummyWeatherData[0]),

        const SizedBox(height: 20),

        const Text(
          '4-Day Forecast',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 10),

        // Horizontal list of forecast cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var weather in dummyWeatherData) forecastCard(weather),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget mainForecastCard(Weather weather) {
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
                '${weather.cityName} (${formatter.format(weather.dateTime)})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                'Temperature: ${weather.temperature}°C',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Wind: ${weather.windSpeed} M/S',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Humidity: ${weather.humidity}%',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            children: [
              // Icon(weather.icon, color: Colors.white, size: 48),
              Image.network(
                'https:${weather.iconUrl}',
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.white);
                },
              ),
              const SizedBox(height: 4),
              Text(
                weather.condition,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget forecastCard(Weather weather) {
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
}
