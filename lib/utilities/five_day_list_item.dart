import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_practice/data_model/weather_data_model.dart';
import 'package:weather_practice/provider/weather_data_provider.dart';
import 'package:weather_practice/utilities/constants.dart';

class FiveDayListItem extends StatelessWidget {
  const FiveDayListItem(
      {required this.weatherDataModel, required this.dayName, super.key});

  final WeatherDataModel weatherDataModel;
  final String dayName;
  @override
  Widget build(BuildContext context) {
    String weatherDescription =
        weatherDataModel.weatherDescription.substring(0, 1).toUpperCase() +
            weatherDataModel.weatherDescription
                .substring(1, weatherDataModel.weatherDescription.length - 1);

    String iconUri = weatherDataModel.iconUri;

    return Padding(
        padding: const EdgeInsets.all(15.0).copyWith(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Expanded(
                  flex: 0,
                  child: SizedBox(
                    height: 10,
                    width: 10,
                    child: CircleAvatar(
                      backgroundColor: kCardColor.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),*/
            Expanded(
              child: Text(
                dayName,
                style: kBodyTextStyle,
              ),
            ),
            Expanded(
              flex: 2,
              child: Opacity(
                opacity: 0.8,
                child: SvgPicture.asset(
                  iconUri,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                "${weatherDataModel.mainTemp.toStringAsFixed(1)}°",
                style: kSmallGiantTextStyle,
              ),
            )
          ],
        ));
  }
}

// Expanded(
// flex: 2,
// child: Text(
// weatherDataModel.weatherDescription
//     .substring(0, 1)
//     .toUpperCase() +
// weatherDataModel.weatherDescription.substring(
// 1, weatherDataModel.weatherDescription.length - 1),
// style: kHeadingTextStyle,
// ),
// ),
