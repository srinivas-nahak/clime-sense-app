import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';
import 'package:weather_practice/utilities/constants.dart';

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

  Future<List<int>> getStoredWeatherData() async {
    //Getting weatherData from memory
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(kLocalStorageWeatherDataKey)) {
      dynamic storedWeatherData = jsonDecode(
              sharedPreferences.get(kLocalStorageWeatherDataKey).toString())
          as Map<String, dynamic>;

      String storedCityName = storedWeatherData["city"]["name"];

      setWeatherDataModel(storedWeatherData, storedCityName);

      //Returning lat and long to see if it's equal to the current location
      double lat = storedWeatherData["city"]["coord"]["lat"];
      double lon = storedWeatherData["city"]["coord"]["lon"];

      return [lat.toInt(), lon.toInt()];
    }
    return [];
  }

  Future<void> saveWeatherData(dynamic weatherData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //Clearing the existing data and putting new
    sharedPreferences.clear();
    await sharedPreferences.setString(
        kLocalStorageWeatherDataKey, jsonEncode(weatherData));
  }

  void fetchCurrentLocationWeather() async {
    //Fetching current location's data from memory
    List<int> storedLocation = await getStoredWeatherData();

    //Getting current lat,lang
    Position position = await LocationFetch().getLocation();

    List<int> fetchedLocation = [
      position.latitude.toInt(),
      position.longitude.toInt()
    ];

    //Checking if stored lat and long are equal to the current location
    if (storedLocation.isNotEmpty &&
        listEquals(storedLocation, fetchedLocation)) {
      return;
    }

    NetworkHelper networkHelper = NetworkHelper();
    var weatherData = await networkHelper.getNetworkData(
        lat: position.latitude, lon: position.longitude, getName: true);

    String cityName = networkHelper.fetchedCityName;

    setWeatherDataModel(weatherData, cityName);

    //Saving weatherData in memory
    saveWeatherData(weatherData);
  }
}

final weatherDataProvider =
    StateNotifierProvider<WeatherNotifier, Map<String, WeatherDataModel>>(
        (ref) => WeatherNotifier());
