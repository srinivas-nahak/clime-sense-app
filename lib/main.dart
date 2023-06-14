import 'package:flutter/material.dart';
import 'package:weather_practice/screens/weather_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true),
      scaffoldMessengerKey: scaffoldKey,
      home: const WeatherScreen(),
    ),
  );
}
