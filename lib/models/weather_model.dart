import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

enum WeatherCondition { sunny, cloudy, rainy, snowy, thunderstorm, foggy }

class Weather {
  final String cityName;
  final double temperature;
  final WeatherCondition condition;
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final DateTime dateTime;

  IconData get icon {
    switch (condition) {
      case WeatherCondition.sunny:
        return WeatherIcons.day_sunny;
      case WeatherCondition.cloudy:
        return WeatherIcons.cloudy;
      case WeatherCondition.rainy:
        return WeatherIcons.rain;
      case WeatherCondition.snowy:
        return WeatherIcons.snow;
      case WeatherCondition.thunderstorm:
        return WeatherIcons.thunderstorm;
      case WeatherCondition.foggy:
        return WeatherIcons.fog;
    }
  }

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.dateTime,
  });

  static WeatherCondition _mapStringToCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return WeatherCondition.sunny;
      case 'cloudy':
        return WeatherCondition.cloudy;
      case 'rainy':
        return WeatherCondition.rainy;
      case 'snowy':
        return WeatherCondition.snowy;
      case 'thunderstorm':
        return WeatherCondition.thunderstorm;
      case 'foggy':
        return WeatherCondition.foggy;
      default:
        return WeatherCondition.sunny;
    }
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'],
      temperature: (json['temperature'] as num).toDouble(),
      condition: _mapStringToCondition(json['condition']),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      humidity: json['humidity'],
      feelsLike: (json['feelsLike'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'condition': condition.name,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'feelsLike': feelsLike,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

final List<Weather> dummyWeatherData = [
  Weather(
    cityName: 'London',
    temperature: 18.71,
    condition: WeatherCondition.rainy,
    windSpeed: 4.31,
    humidity: 76,
    feelsLike: 18.0,
    dateTime: DateTime(2023, 6, 19),
  ),
  Weather(
    cityName: 'London',
    temperature: 17.64,
    condition: WeatherCondition.cloudy,
    windSpeed: 0.73,
    humidity: 70,
    feelsLike: 17.0,
    dateTime: DateTime(2023, 6, 20),
  ),
  Weather(
    cityName: 'London',
    temperature: 16.78,
    condition: WeatherCondition.sunny,
    windSpeed: 2.72,
    humidity: 83,
    feelsLike: 16.5,
    dateTime: DateTime(2023, 6, 21),
  ),
  Weather(
    cityName: 'London',
    temperature: 18.20,
    condition: WeatherCondition.thunderstorm,
    windSpeed: 1.49,
    humidity: 72,
    feelsLike: 18.0,
    dateTime: DateTime(2023, 6, 22),
  ),
  Weather(
    cityName: 'London',
    temperature: 17.08,
    condition: WeatherCondition.rainy,
    windSpeed: 0.9,
    humidity: 89,
    feelsLike: 17.0,
    dateTime: DateTime(2023, 6, 23),
  ),
];
