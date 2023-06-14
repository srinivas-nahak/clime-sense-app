import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';

import '../main.dart';

class WeatherNotifier extends StateNotifier<Map<String, WeatherDataModel>> {
  WeatherNotifier() : super({});

  void updateDataModel(dynamic weatherData, [String inputCity = ""]) {
    try {
      //controller.clear();

      String cityName = "";

      if (inputCity != "") {
        if (inputCity.contains(",")) {
          cityName = inputCity.substring(0, inputCity.indexOf(","));
        } else {
          cityName = inputCity;
        }
      }

      double todayMainTemp = weatherData["days"][0]["temp"];
      double todayTempMin = weatherData["days"][0]["tempmin"];
      double todayTempMax = weatherData["days"][0]["tempmax"];
      String todayWeatherDescription =
          weatherData["days"][0]["description"].toString().toLowerCase();

      double tomorrowMainTemp = weatherData["days"][1]["temp"];
      double tomorrowTempMin = weatherData["days"][1]["tempmin"];
      double tomorrowTempMax = weatherData["days"][1]["tempmax"];
      String tomorrowWeatherDescription =
          weatherData["days"][1]["description"].toString().toLowerCase();

      double dayAfterMainTemp = weatherData["days"][2]["temp"];
      double dayAfterTempMin = weatherData["days"][2]["tempmin"];
      double dayAfterTempMax = weatherData["days"][2]["tempmax"];
      String dayAfterWeatherDescription =
          weatherData["days"][2]["description"].toString().toLowerCase();

      Map<String, WeatherDataModel> weatherMap = {
        "today": WeatherDataModel(
            cityName: cityName,
            mainTemp: todayMainTemp,
            tempMin: todayTempMin,
            tempMax: todayTempMax,
            weatherDescription: todayWeatherDescription),
        "tomorrow": WeatherDataModel(
            cityName: cityName,
            mainTemp: tomorrowMainTemp,
            tempMin: tomorrowTempMin,
            tempMax: tomorrowTempMax,
            weatherDescription: tomorrowWeatherDescription),
        "dayAfter": WeatherDataModel(
            cityName: cityName,
            mainTemp: dayAfterMainTemp,
            tempMin: dayAfterTempMin,
            tempMax: dayAfterTempMax,
            weatherDescription: dayAfterWeatherDescription)
      };

      state = {...state, ...weatherMap};
    } catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}

final weatherDataProvider =
    StateNotifierProvider<WeatherNotifier, Map<String, WeatherDataModel>>(
        (ref) => WeatherNotifier());
