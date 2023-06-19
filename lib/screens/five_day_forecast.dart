import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_practice/provider/weather_data_provider.dart';

import '../data_model/weather_data_model.dart';
import '../utilities/blurry_circle.dart';
import '../utilities/constants.dart';
import '../utilities/five_day_list_item.dart';

class FiveDayForecastList extends ConsumerWidget {
  const FiveDayForecastList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fiveDayWeatherData = ref.read(weatherDataProvider);

    return Padding(
      padding: const EdgeInsets.all(25.0).copyWith(top: 10),
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
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            //mini: true,
            backgroundColor: kCardColor.withOpacity(0.08),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Icon(
              Icons.close,
              color: kCardColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
