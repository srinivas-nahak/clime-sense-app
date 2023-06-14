import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_practice/main.dart';
import 'package:weather_practice/utilities/constants.dart';

class NetworkHelper {
  String locationKey = "";
  String fetchedCityName = "";
  String weatherUrl = "";

  Future<dynamic> getNetworkData(
      {double? lat,
      double? lon,
      String cityName = "",
      bool getName = false}) async {
    http.Response response;

    //TODO:Try to use conditional operator to minimize if-else usage

    if (getName) {
      String latLong =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$kGoogleMapApi";

      http.Response nameResponse = await http.get(Uri.parse(latLong));
      var nameList = jsonDecode(nameResponse.body);

      fetchedCityName =
          nameList["results"][1]["address_components"][1]["long_name"];

      if (fetchedCityName.contains(",")) {
        fetchedCityName =
            fetchedCityName.substring(0, fetchedCityName.indexOf(","));
      }
    }

    weatherUrl =
        "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$lat,$lon?unitGroup=metric&include=days&key=$kVisualCrossingApi&contentType=json";

    http.Response weatherResponse = await http.get(Uri.parse(weatherUrl));

    if (weatherResponse.statusCode != 200) {
      scaffoldKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("Some network error happened! Please try again."),
        ),
      );

      return;
    }
    var weatherData = jsonDecode(weatherResponse.body);

    if (cityName != "") {
      fetchedCityName = weatherData["resolvedAddress"];
      if (fetchedCityName.contains(",")) {
        fetchedCityName =
            fetchedCityName.substring(0, fetchedCityName.indexOf(","));
      }
    }

    return weatherData;
  }
}
