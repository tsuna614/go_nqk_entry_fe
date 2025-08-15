import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:intl/intl.dart';

class MainForecastCard extends StatelessWidget {
  const MainForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherStates>(
      builder: (context, state) {
        if (state is WeatherLoadingState ||
            state is WeatherInitialState ||
            state is WeatherErrorState) {
          return buildForecastCardShimmer(context);
        } else if (state is WeatherLoadedState) {
          final weatherData = state.currentWeather;
          return buildForecastCard(context, weatherData, state.currentPage);
        } else {
          return const Center(child: Text('No weather data available'));
        }
      },
    );
  }

  Widget buildForecastCard(
    BuildContext context,
    Weather weatherData,
    int currentPage,
  ) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                'Temperature: ${weatherData.temperature}°C',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Wind: ${weatherData.windSpeed} M/S',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Humidity: ${weatherData.humidity}%',
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
            ],
          ),
          Column(
            children: [
              // Icon(weatherData.icon, color: Theme.of(context).secondaryHeaderColor, size: 48),
              Image.network(
                'https:${weatherData.iconUrl}',
                width: 48,
                height: 48,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    color: Theme.of(context).secondaryHeaderColor,
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                weatherData.condition,
                style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildForecastCardShimmer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
