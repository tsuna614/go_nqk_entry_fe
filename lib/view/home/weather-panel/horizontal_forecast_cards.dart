import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/cubit/constraint_cubit.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_events.dart';
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
  void changePage(bool isForward) async {
    if (widget.state is! WeatherLoadedState) return;

    int changedPage = (isForward
        ? (widget.state as WeatherLoadedState).currentPage + 1
        : (widget.state as WeatherLoadedState).currentPage - 1);

    if (changedPage >= 4) {
      // temporarily hardcoded limit, because we know the weather API won't return more than 14 days forecast
      return;
    }

    context.read<WeatherBloc>().add(
      FetchWeatherEvent(
        city: (widget.state as WeatherLoadedState).city,
        page: changedPage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 40),
          onPressed: () => changePage(false),
        ),

        // Wrap LayoutBuilder in Flexible instead of inside it
        Flexible(
          child: Builder(
            builder: (context) {
              final constraints = context.watch<ConstraintsCubit>().state;

              if (constraints == null) {
                // Fallback while constraints are not yet set
                return const SizedBox();
              }

              if (constraints.maxWidth > 600) {
                // Wide screen: horizontal scroll
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.state is WeatherLoadingState ||
                          widget.state is WeatherInitialState ||
                          (widget.state is WeatherLoadedState &&
                              (widget.state as WeatherLoadedState)
                                  .isLoadingMore))
                        ...List.generate(
                          4,
                          (index) => buildShimmerForecastCard(),
                        )
                      else if (widget.state is WeatherLoadedState)
                        ...((widget.state as WeatherLoadedState)
                            .currentWeatherList
                            .map((weather) => buildForecastCard(weather)))
                      else
                        const Center(child: Text('No weather data available')),
                    ],
                  ),
                );
              } else {
                // Small screen: grid
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if (widget.state is WeatherLoadingState ||
                        widget.state is WeatherInitialState)
                      ...List.generate(4, (index) => buildShimmerForecastCard())
                    else if (widget.state is WeatherLoadedState)
                      ...((widget.state as WeatherLoadedState)
                          .currentWeatherList
                          .map((weather) => buildNarrowForecastCard(weather)))
                    else
                      const Center(child: Text('No weather data available')),
                  ],
                );
              }
            },
          ),
        ),

        IconButton(
          icon: const Icon(Icons.arrow_forward_rounded, size: 40),
          onPressed: () => changePage(true),
        ),
      ],
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

  Widget buildNarrowForecastCard(Weather weather) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fill available height
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // even spacing
                  children: [
                    Text(
                      formatter.format(weather.dateTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.network(
                      'https:${weather.iconUrl}',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.white);
                      },
                    ),
                    Text(
                      'Temp: ${weather.temperature}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Wind: ${weather.windSpeed}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Humidity: ${weather.humidity}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
