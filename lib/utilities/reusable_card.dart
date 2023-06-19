import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_practice/main.dart';

import 'constants.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {required this.bodyText,
      required this.onPressed,
      required this.weatherIconName,
      super.key});

  final String bodyText;
  final VoidCallback onPressed;
  final kWeatherIconName weatherIconName;

  void _showSnackBar(String message) {
    if (message.contains("%")) {
      message = "Humidity is $message";
    } else if (message.contains("km/h")) {
      message = "Wind speed is $message";
    } else {
      message = "Current sea level is $message";
    }

    scaffoldKey.currentState?.clearSnackBars();
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: kBackgroundColor.withOpacity(0.8),
        closeIconColor: kBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10).copyWith(left: 25),
        duration: const Duration(seconds: 3),
        content: Text(
          message,
          style: kBodyTextStyle,
        ),
        action: SnackBarAction(
            label: "Dismiss",
            textColor: kCardColor.withOpacity(0.5),
            onPressed: () => scaffoldKey.currentState!.hideCurrentSnackBar()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCardColor.withOpacity(0.07),
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showSnackBar(bodyText),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(children: [
            SvgPicture.asset(
              kWeatherIconSet[weatherIconName]!,
              width: 40,
            ),
            Text(
              bodyText,
              style:
                  kBodyTextStyle.copyWith(color: kCardColor.withOpacity(0.5)),
            ),
          ]),
        ),
      ),
    );
  }
}
