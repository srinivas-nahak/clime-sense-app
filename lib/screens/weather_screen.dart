import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';
import 'package:weather_practice/provider/weather_data_provider.dart';
import 'package:weather_practice/screens/five_day_forecast.dart';
import 'package:weather_practice/screens/splash_screen.dart';
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
    //ref.read(weatherDataProvider.notifier).fetchCurrentLocationWeather();

    super.initState();
  }

  void _showFiveDayWeather() {
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
                const FiveDayForecastList(),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    WeatherDataModel? today = ref.watch(weatherDataProvider
        .select((weatherDataMap) => weatherDataMap[kDayName.day1]));

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
                  height: MediaQuery.of(context).size.height + 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
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
                          Expanded(
                            child: GoogleTextField(
                              sendData: (weatherData, cityName) => ref
                                  .read(weatherDataProvider.notifier)
                                  .setWeatherDataModel(weatherData, cityName),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          )
                        ],
                      ),
                      Expanded(
                        flex: 3,
                        child: Opacity(
                            opacity: 0.8,
                            child: SvgPicture.asset(
                              iconUri,
                              width: 230,
                            )),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 20),
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
                          padding: const EdgeInsets.only(left: 25, right: 100),
                          child: Text(
                            "It's ${today?.weatherDescription ?? ""}",
                            textAlign: TextAlign.left,
                            style: kBodyTextStyle.copyWith(
                                color: kCardColor.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
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
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 15, left: 15, right: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ReusableCard(
                                  onPressed: () => _showFiveDayWeather(),
                                  bodyText: "${today?.humidity}%",
                                  weatherIconName: kWeatherIconName.humidity,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ReusableCard(
                                  onPressed: () => _showFiveDayWeather(),
                                  bodyText:
                                      "${today?.windSpeed.toStringAsFixed(1)} km/h",
                                  weatherIconName: kWeatherIconName.windSpeed,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ReusableCard(
                                  onPressed: () => _showFiveDayWeather(),
                                  bodyText: "${today?.seaLevel} m",
                                  weatherIconName: kWeatherIconName.seaLevel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Using SizedBox+Material instead of just Container for better splash effect
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: SizedBox(
                          height: 70,
                          child: Material(
                            color: kCardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              onTap: () => _showFiveDayWeather(),
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
