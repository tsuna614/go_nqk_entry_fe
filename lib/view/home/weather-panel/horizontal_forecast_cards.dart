import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/cubit/constraint_cubit.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_events.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/models/weather_model.dart';
import 'package:intl/intl.dart';

class HorizontalForecastCards extends StatefulWidget {
  const HorizontalForecastCards({super.key});

  @override
  State<HorizontalForecastCards> createState() =>
      _HorizontalForecastCardsState();
}

class _HorizontalForecastCardsState extends State<HorizontalForecastCards> {
  void changePage(bool isForward, WeatherStates state) async {
    if (state is! WeatherLoadedState) return;

    int changedPage = (isForward
        ? state.currentPage + 1
        : state.currentPage - 1);

    if (changedPage >= 4) {
      // temporarily hardcoded limit, because we know the weather API won't return more than 14 days forecast
      return;
    }

    context.read<WeatherBloc>().add(
      FetchWeatherEvent(city: state.city, page: changedPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherStates>(
      builder: (context, state) {
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, size: 40),
              onPressed: () => changePage(false, state),
            ),
            Flexible(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Builder(
                  key: ValueKey<int>(
                    state is WeatherLoadedState ? state.currentPage : -1,
                  ),
                  builder: (context) {
                    final constraints = context.watch<ConstraintsCubit>().state;

                    if (constraints == null) return const SizedBox();

                    if (constraints.maxWidth > 600) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (state is WeatherLoadingState ||
                                state is WeatherInitialState ||
                                state is WeatherErrorState)
                              ...List.generate(
                                4,
                                (index) => buildShimmerForecastCard(),
                              )
                            else if (state is WeatherLoadedState)
                              ...(state.currentWeatherList.map(
                                (weather) => buildForecastCard(weather),
                              )),
                          ],
                        ),
                      );
                    } else {
                      return GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          if (state is WeatherLoadingState ||
                              state is WeatherInitialState)
                            ...List.generate(
                              4,
                              (index) => buildShimmerForecastCard(),
                            )
                          else if (state is WeatherLoadedState)
                            ...(state.currentWeatherList.map(
                              (weather) => buildNarrowForecastCard(weather),
                            ))
                          else
                            const Center(
                              child: Text('No weather data available'),
                            ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            IconButton(
              icon: const Icon(Icons.arrow_forward_rounded, size: 40),
              onPressed: () => changePage(true, state),
            ),
          ],
        );
      },
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
