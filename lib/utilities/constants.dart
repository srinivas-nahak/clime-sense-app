import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Colors
const kBackgroundColor = Color(0XFF1E1E1E);

const kBlurryCircleColor = Color(0XFFc7a9b7);

const kCardColor = Color(0XFFBFAEB6); //OXFFC9B8C0

//Text Styles
const kGiantTextStyle = TextStyle(
  fontSize: 125,
  fontWeight: FontWeight.w300,
  color: kCardColor,
);

const kSmallGiantTextStyle =
    TextStyle(fontSize: 35, fontWeight: FontWeight.w300, color: kCardColor);

const kBodyTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w300,
  color: kCardColor,
);

final kTextFieldTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  color: kBackgroundColor.withOpacity(0.75),
);

const kHeadingTextStyle = TextStyle(
  fontSize: 20,
  height: 2,
  fontWeight: FontWeight.w400,
  color: kCardColor,
);

//Keys

const kGoogleMapApiKey = "AIzaSyCWU987khOwMKgxsDP8kc6AzQWnuaMWkBM";

const kOpenWeatherApiKey = "02321fbfe8bf5bb425d1a5f93e26d8ae";

const kLocalStorageWeatherDataKey = "currentWeatherData";

//To avoid typo error enum is used as the key for map and not string
enum kWeatherIconName {
  cloudy,
  sunny,
  snowy,
  rainy,
  cloudySunny,
  overcastCloudy,
  moon,
  windSpeed,
  humidity,
  seaLevel,
  appIcon
}

const Map<kWeatherIconName, String> kWeatherIconSet = {
  kWeatherIconName.cloudy: "assets/icons/icon_cloudy.svg",
  kWeatherIconName.cloudySunny: "assets/icons/icon_cloudy_sunny.svg",
  kWeatherIconName.rainy: "assets/icons/icon_rainy.svg",
  kWeatherIconName.snowy: "assets/icons/icon_snowy.svg",
  kWeatherIconName.sunny: "assets/icons/icon_sunny.svg",
  kWeatherIconName.overcastCloudy: "assets/icons/icon_overcast_cloudy.svg",
  kWeatherIconName.moon: "assets/icons/icon_moon.svg",
  kWeatherIconName.windSpeed: "assets/icons/icon_wind_speed.svg",
  kWeatherIconName.humidity: "assets/icons/icon_humidity.svg",
  kWeatherIconName.seaLevel: "assets/icons/icon_sea_level.svg",
  kWeatherIconName.appIcon: "assets/icons/clime_sense_app_icon.svg"
};

enum kDayName { day1, day2, day3, day4, day5 }

//Getting dayName Monday, Tuesday ...
String kGetDayName(int index) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  if (index == 0) return "Today";

  //So here we're determining the day name based on index of kDayName enum
  //which is being passed from Five_Day_Forecast class
  String day = DateFormat("EEEE").format(today.copyWith(day: now.day + index));

  return day;
}

//Unused Colors

//const kBrightCircleColor = Color(0XFFFFF4D4);
// const kBrownColor = Color(0XFF6F4F45);
//
// const kLightBrownColor = Color(0XFFD19C8C);
//
// const kBackgroundLightColor = Color(0XFFFEAC97);
// const kRustyPinkColor = Color(0XFF9e616b);
