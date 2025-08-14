import 'package:flutter/material.dart';
import 'package:go_nqk_entry_fe/bloc/weather-bloc/weather_states.dart';
import 'package:go_nqk_entry_fe/view/home/weather-panel/horizontal_forecast_cards.dart';
import 'package:go_nqk_entry_fe/view/home/weather-panel/main_forecast_card.dart';

class WeatherPanel extends StatelessWidget {
  final WeatherStates state;
  const WeatherPanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The main big forecast card
        MainForecastCard(state: state),

        const SizedBox(height: 20),

        const Text(
          '4-Day Forecast',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 10),

        HorizontalForecastCards(state: state),

        // // Horizontal list of forecast cards
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: SizedBox(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         for (var weather in dummyWeatherData) forecastCard(weather),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
