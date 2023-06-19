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

class WeatherNotifier extends StateNotifier<Map<kDayName, WeatherDataModel>> {
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

      Map<kDayName, WeatherDataModel> weatherMap =
          <kDayName, WeatherDataModel>{};

      for (int i = 0; i <= 32; i += 8) {
        num mainTemp = weatherData["list"][i]["main"]["temp"];
        num tempMin = weatherData["list"][i]["main"]["temp_min"];
        num tempMax = weatherData["list"][i]["main"]["temp_max"];

        num seaLevel = weatherData["list"][i]["main"]["sea_level"];
        num humidity = weatherData["list"][i]["main"]["humidity"];
        num windSpeed = weatherData["list"][i]["wind"]["speed"];

        String iconId = weatherData["list"][i]["weather"][0]["icon"];
        String weatherDescription = weatherData["list"][i]["weather"][0]
                ["description"]
            .toString()
            .toLowerCase();

        //Showing snow icon for the 1st day of cold places
        // because openWeatherMap doesn't provide snow icon id always
        if (i == 0 && mainTemp < -6) {
          iconId = "13d";
        }

        weatherMap = {
          ...weatherMap,
          getDayName(i): WeatherDataModel(
              cityName: cityName,
              mainTemp: mainTemp,
              tempMin: tempMin,
              tempMax: tempMax,
              iconUri: _getIconUri(iconId),
              weatherDescription: weatherDescription,
              seaLevel: seaLevel,
              windSpeed: windSpeed,
              humidity: humidity)
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

  //Here we're giving the dayName key for storing the weather data
  kDayName getDayName(int index) => kDayName.values[index ~/ 8];

  String _getIconUri(String iconId) {
    //Replacing "n" with "d" to avoid unnecessary switch statements
    if (iconId.contains("n") && iconId != "01n") {
      iconId = "${iconId.substring(0, 2)}d";
    }

    switch (iconId) {
      case "01d":
        return kWeatherIconSet[kWeatherIconName.sunny]!;
      case "01n":
        return kWeatherIconSet[kWeatherIconName.moon]!;

      case "02d":
      case "03d":
        return kWeatherIconSet[kWeatherIconName.cloudySunny]!;

      case "09d":
      case "04d":
        return kWeatherIconSet[kWeatherIconName.overcastCloudy]!;

      case "10d":
      case "11d":
        return kWeatherIconSet[kWeatherIconName.rainy]!;

      case "13d":
        return kWeatherIconSet[kWeatherIconName.snowy]!;

      case "50d":
        return kWeatherIconSet[kWeatherIconName.cloudy]!;

      default:
        return kWeatherIconSet[kWeatherIconName.cloudySunny]!;
    }
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
    //To avoid api call
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
    StateNotifierProvider<WeatherNotifier, Map<kDayName, WeatherDataModel>>(
        (ref) => WeatherNotifier());
