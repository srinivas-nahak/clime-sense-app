import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';
import 'package:weather_practice/provider/weather_data_provider.dart';
import 'package:weather_practice/utilities/reusable_card.dart';
import '../googleTextField/google_text_field.dart';
import 'package:weather_practice/utilities/constants.dart';

import '../utilities/blurry_circle.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  @override
  initState() {
    //Fetching the current location's weather data
    ref.read(weatherDataProvider.notifier).fetchCurrentLocationWeather();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WeatherDataModel> weatherDataModel =
        ref.watch(weatherDataProvider);

    WeatherDataModel? today = weatherDataModel["dayOne"];
    WeatherDataModel? tomorrow = weatherDataModel["dayTwo"];
    WeatherDataModel? dayAfter = weatherDataModel["dayThree"];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlurryCircle(circleColor: kBlurryCircleColor.withOpacity(0.4)),
            Padding(
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
                          onPressed: () => ref
                              .read(weatherDataProvider.notifier)
                              .fetchCurrentLocationWeather(),
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
                          sendData: (weatherData, cityName) => ref
                              .read(weatherDataProvider.notifier)
                              .setWeatherDataModel(weatherData, cityName),
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
                        today?.cityName ?? "",
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
                        "It's ${today?.weatherDescription ?? ""}",
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
                        "${today?.mainTemp.toStringAsFixed(1)}°",
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
                            child: ReusableCard(
                                heading: "Today",
                                body:
                                    "${today?.tempMax.toInt()}°/${today?.tempMin.toInt()}°"),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ReusableCard(
                                heading: "Tomorrow",
                                body:
                                    "${tomorrow?.tempMax.toInt()}°/${tomorrow?.tempMin.toInt()}°"),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ReusableCard(
                                heading: "Day After",
                                body:
                                    "${dayAfter?.tempMax.toInt()}°/${dayAfter?.tempMin.toInt()}°"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Closing the keyboard if it's open
// if (FocusManager.instance.primaryFocus!.hasFocus) {
// FocusManager.instance.primaryFocus?.unfocus();
// } else {
// FocusManager.instance.primaryFocus?.hasFocus;
// }
