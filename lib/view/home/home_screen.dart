import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_nqk_entry_fe/bloc/cubit/constraint_cubit.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'Weather Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<WeatherBloc, WeatherStates>(
        listener: (context, state) {
          if (state is WeatherErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
          }
          return BlocProvider(
            create: (_) => ConstraintsCubit(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                context.read<ConstraintsCubit>().setConstraints(constraints);

                if (constraints.maxWidth > 600) {
                  return _buildWideHomeScreen();
                } else {
                  return _buildNarrowHomeScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildWideHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE - Search form
          Expanded(flex: 2, child: SearchForm()),

          const SizedBox(width: 20),

          // RIGHT SIDE - Weather info
          Expanded(flex: 3, child: WeatherPanel()),
        ],
      ),
    );
  }

  Widget _buildNarrowHomeScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SearchForm(), const SizedBox(height: 20), WeatherPanel()],
      ),
    );
  }
}
