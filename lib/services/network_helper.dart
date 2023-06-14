import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_practice/main.dart';
import 'package:weather_practice/utilities/constants.dart';

class NetworkHelper {
  String fetchedCityName = "";
  String weatherUrl = "";

  Future<dynamic> getNetworkData(
      {double? lat, double? lon, bool getName = false}) async {
    weatherUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$kOpenWeatherApiKey&units=metric";
    http.Response weatherResponse = await http.get(Uri.parse(weatherUrl));

    //Showing error message
    if (weatherResponse.statusCode != 200) {
      scaffoldKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Some network error happened! Please try again."),
        ),
      );

      return;
    }
    var weatherData = jsonDecode(weatherResponse.body);

    //Using the fetchedCityName for current location
    fetchedCityName = weatherData["city"]["name"];

    return weatherData;
  }
}
