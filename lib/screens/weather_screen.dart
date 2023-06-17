import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';
import 'package:weather_practice/provider/weather_data_provider.dart';
import 'package:weather_practice/screens/five_day_forecast.dart';
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

  void _showFiveDayWeather(Map<kDayName, WeatherDataModel> mainWeatherData) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: kBackgroundColor,
        isDismissible: true,
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (context) => Stack(
              children: [
                BlurryCircle(
                  circleColor: kBlurryCircleColor.withOpacity(0.3),
                ),
                /*BlurryCircle(
                  circleColor: kBlurryCircleColor.withOpacity(0.03),
                  blurAmount: 0,
                ),*/
                FiveDayForecastList(fiveDayWeatherData: mainWeatherData),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    Map<kDayName, WeatherDataModel> mainWeatherData =
        ref.watch(weatherDataProvider);

    WeatherDataModel? today = mainWeatherData[kDayName.day1];
    WeatherDataModel? tomorrow = mainWeatherData[kDayName.day2];
    WeatherDataModel? dayAfter = mainWeatherData[kDayName.day3];

    String iconUri = today?.iconUri ?? const WeatherDataModel().iconUri;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlurryCircle(circleColor: kBlurryCircleColor.withOpacity(0.3)),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
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
                              splashColor: Colors.white,
                              icon: Icon(
                                Icons.near_me,
                                size: 30,
                                color: kCardColor.withOpacity(0.45),
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
                        flex: 2,
                        child: Opacity(
                            opacity: 0.8,
                            child: SvgPicture.asset(
                              iconUri,
                              width: 250,
                            )),
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
                      Expanded(
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
                        padding: const EdgeInsets.all(15).copyWith(top: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: ReusableCard(
                                    onPressed: () =>
                                        _showFiveDayWeather(mainWeatherData),
                                    heading: "Today",
                                    body:
                                        "${today?.tempMax.toInt()}°/${today?.tempMin.toInt()}°"),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: ReusableCard(
                                    onPressed: () =>
                                        _showFiveDayWeather(mainWeatherData),
                                    heading: "Tomorrow",
                                    body:
                                        "${tomorrow?.tempMax.toInt()}°/${tomorrow?.tempMin.toInt()}°"),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: ReusableCard(
                                    onPressed: () =>
                                        _showFiveDayWeather(mainWeatherData),
                                    heading: "Day After",
                                    body:
                                        "${dayAfter?.tempMax.toInt()}°/${dayAfter?.tempMin.toInt()}°"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: SizedBox(
                          height: 70,
                          child: Material(
                            color: kCardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              onTap: () => _showFiveDayWeather(mainWeatherData),
                              borderRadius: BorderRadius.circular(25),
                              child: const Center(
                                  child: Text(
                                "5 day forecast",
                                style: kHeadingTextStyle,
                              )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
