import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';

import '../main.dart';
import '../services/location_fetch.dart';
import '../services/network_helper.dart';

class WeatherNotifier extends StateNotifier<Map<String, WeatherDataModel>> {
  WeatherNotifier() : super({});

  void setWeatherDataModel(dynamic weatherData, [String inputCity = ""]) {
    try {
      String cityName = "";

      if (inputCity != "") {
        if (inputCity.contains(",")) {
          cityName = inputCity.substring(0, inputCity.indexOf(","));
        } else {
          cityName = inputCity;
        }
      }

      ///As the API is providing 5 days 3 hours data i.e 8 chunks per day, so we're using 0-8-16 indices

      Map<String, WeatherDataModel> weatherMap = <String, WeatherDataModel>{};

      for (int i = 0; i <= 32; i += 8) {
        num mainTemp = weatherData["list"][i]["main"]["temp"];
        num tempMin = weatherData["list"][i]["main"]["temp_min"];
        num tempMax = weatherData["list"][i]["main"]["temp_max"];
        String weatherDescription = weatherData["list"][i]["weather"][0]
                ["description"]
            .toString()
            .toLowerCase();

        weatherMap = {
          ...weatherMap,
          getDayName(i): WeatherDataModel(
              cityName: cityName,
              mainTemp: mainTemp,
              tempMin: tempMin,
              tempMax: tempMax,
              weatherDescription: weatherDescription)
        };
      }

      state = {...state, ...weatherMap};
    } catch (e) {
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return "dayOne";

      case 8:
        return "dayTwo";

      case 16:
        return "dayThree";

      case 24:
        return "dayFour";

      case 32:
        return "dayFive";
    }
    return "";
  }

  void fetchLocationWeather() async {
    Position position = await LocationFetch().getLocation();

    NetworkHelper networkHelper = NetworkHelper();

    var weatherData = await networkHelper.getNetworkData(
        lat: position.latitude, lon: position.longitude, getName: true);

    String cityName = networkHelper.fetchedCityName;

    setWeatherDataModel(weatherData, cityName);
  }
}

final weatherDataProvider =
    StateNotifierProvider<WeatherNotifier, Map<String, WeatherDataModel>>(
        (ref) => WeatherNotifier());
