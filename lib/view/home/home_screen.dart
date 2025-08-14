import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_events.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/view/home/search_form.dart';
import 'package:go_nqk_entry_fe/view/home/weather-panel/weather_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9EAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B7BE4),
        elevation: 0,
        title: const Text(
          'Weather Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<WeatherBloc, WeatherStates>(
        builder: (context, state) {
          if (state is WeatherInitialState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Ensure BLoC is available before reading
              if (context.mounted) {
                context.read<WeatherBloc>().add(
                  FetchWeatherEvent(city: "London", page: 0),
                );
              }
            });
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state is WeatherErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 600) {
                return _buildWideHomeScreen(state);
              } else {
                return _buildNarrowHomeScreen(state);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildWideHomeScreen(WeatherStates state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE - Search form
          Expanded(flex: 2, child: SearchForm()),

          const SizedBox(width: 20),

          // RIGHT SIDE - Weather info
          Expanded(flex: 3, child: WeatherPanel(state: state)),
        ],
      ),
    );
  }

  Widget _buildNarrowHomeScreen(WeatherStates state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchForm(),
          const SizedBox(height: 20),
          WeatherPanel(state: state),
        ],
      ),
    );
  }
}
