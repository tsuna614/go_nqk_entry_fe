import 'package:flutter/material.dart';
import 'package:go_nqk_entry_fe/view/home/search_form.dart';
import 'package:go_nqk_entry_fe/view/home/weather_panel.dart';

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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideHomeScreen();
          } else {
            return _buildNarrowHomeScreen();
          }
        },
      ),
    );
  }

  Widget _buildWideHomeScreen() {
    return Padding(
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
