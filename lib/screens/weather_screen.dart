import 'package:flutter/material.dart';
import 'package:weather_practice/main.dart';
import '../googleTextField/google_text_field.dart';
import 'package:weather_practice/services/location_fetch.dart';
import 'package:weather_practice/services/network_helper.dart';
import 'package:weather_practice/utilities/constants.dart';

import '../utilities/blurry_circle.dart';

NetworkHelper networkHelper = NetworkHelper();

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return WeatherScreenState();
  }
}

class WeatherScreenState extends State<WeatherScreen> {
  var controller = TextEditingController();

  double todayTempMin = 0,
      todayTempMax = 0,
      todayFinalTemp = 0,
      tomorrowTempMin = 0,
      tomorrowTempMax = 0,
      dayAfterTempMin = 0,
      dayAfterTempMax = 0;

  String weatherDescription = "", cityName = "";

  @override
  void initState() {
    super.initState();
    fetchLocationWeather();
  }

  fetchLocationWeather() {
    LocationFetch().getLocation().then((position) async {
      var weatherData = await networkHelper.getNetworkData(
          lat: position.latitude, lon: position.longitude, getName: true);

      cityName = networkHelper.fetchedCityName;
      _updateUI(weatherData);
    });
  }

  _updateUI(dynamic weatherData, [String inputCity = ""]) {
    setState(() {
      try {
        controller.clear();

        if (inputCity != "") {
          if (inputCity.contains(",")) {
            cityName = inputCity.substring(0, inputCity.indexOf(","));
          } else {
            cityName = inputCity;
          }
        }

        weatherDescription =
            weatherData["days"][0]["description"].toString().toLowerCase();

        todayTempMin = weatherData["days"][0]["tempmin"];
        todayTempMax = weatherData["days"][0]["tempmax"];

        todayFinalTemp = weatherData["days"][0]["temp"];

        tomorrowTempMin = weatherData["days"][1]["tempmin"];
        tomorrowTempMax = weatherData["days"][1]["tempmax"];

        dayAfterTempMin = weatherData["days"][2]["tempmin"];
        dayAfterTempMax = weatherData["days"][2]["tempmax"];
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    });
  }

  Card getBottomCard({BuildContext? context, String? heading, String? body}) {
    return Card(
      color: kCardColor.withOpacity(0.1),
      /*shape: RoundedRectangleBorder(
        side: BorderSide(
          color: kCardColor.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),*/
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(children: [
          Text(
            heading!,
            style: kHeadingTextStyle,
          ),
          Text(
            body!,
            style: kBodyTextStyle,
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          BlurryCircle(kBlurryCircleColor.withOpacity(0.4)),
          const Expanded(child: SizedBox()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () => fetchLocationWeather(),
                          icon: const Icon(
                            Icons.near_me,
                            size: 30,
                            color: kCardColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: GoogleTextField(
                          sendData: _updateUI,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  Expanded(
                    child: Icon(
                      Icons.cloud,
                      size: 160,
                      color: kCardColor.withOpacity(0.6),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        cityName,
                        textAlign: TextAlign.left,
                        style: kSmallGiantTextStyle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 100),
                      child: Text(
                        "It's $weatherDescription",
                        textAlign: TextAlign.left,
                        style: kHeadingTextStyle.copyWith(
                            color: kCardColor.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: Align(
                      alignment: Alignment.center,
                      widthFactor: double.infinity,
                      child: Text(
                        "${todayFinalTemp.toStringAsFixed(1)}°",
                        textAlign: TextAlign.left,
                        style: kGiantTextStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: getBottomCard(
                                context: context,
                                heading: "Today",
                                body:
                                    "${todayTempMax.toInt()}°/${todayTempMin.toInt()}°"),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: getBottomCard(
                                context: context,
                                heading: "Tomorrow",
                                body:
                                    "${tomorrowTempMax.toInt()}°/${tomorrowTempMin.toInt()}°"),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: getBottomCard(
                                context: context,
                                heading: "Day After",
                                body:
                                    "${dayAfterTempMax.toInt()}°/${dayAfterTempMin.toInt()}°"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef SendData = void Function(dynamic weatherData, String cityName);

//Closing the keyboard if it's open
// if (FocusManager.instance.primaryFocus!.hasFocus) {
// FocusManager.instance.primaryFocus?.unfocus();
// } else {
// FocusManager.instance.primaryFocus?.hasFocus;
// }
