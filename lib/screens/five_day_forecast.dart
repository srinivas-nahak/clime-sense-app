import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_model/weather_data_model.dart';
import '../utilities/blurry_circle.dart';
import '../utilities/constants.dart';
import '../utilities/five_day_list_item.dart';

class FiveDayForecastList extends StatelessWidget {
  const FiveDayForecastList({required this.fiveDayWeatherData, super.key});

  final Map<kDayName, WeatherDataModel> fiveDayWeatherData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Expanded(
            child: Text(
              "Five Days",
              style: kGiantTextStyle.copyWith(
                fontSize: 115,
                height: 1,
                color: kCardColor.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: fiveDayWeatherData.length,
                itemBuilder: (context, index) {
                  return FiveDayListItem(
                    weatherDataModel:
                        fiveDayWeatherData[kDayName.values[index]]!,
                    dayName: kGetDayName(index),
                  );
                }),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
