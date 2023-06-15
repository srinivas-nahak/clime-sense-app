import 'package:flutter/material.dart';

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

const kHeadingTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w300,
  color: kCardColor,
);

final kTextFieldTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  color: kBackgroundColor.withOpacity(0.75),
);

const kBodyTextStyle = TextStyle(
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
enum kWeatherIcon { cloudy, sunny, snowy, rainy, cloudySunny }

const Map<kWeatherIcon, String> kWeatherIconSet = {
  kWeatherIcon.cloudy: "assets/icons/icon_cloudy.svg",
  kWeatherIcon.cloudySunny: "assets/icons/icon_cloudy_sunny.svg",
  kWeatherIcon.rainy: "assets/icons/icon_rainy.svg",
  kWeatherIcon.snowy: "assets/icons/icon_snowy.svg",
  kWeatherIcon.sunny: "assets/icons/icon_sunny.svg",
};

//Unused Colors

//const kBrightCircleColor = Color(0XFFFFF4D4);
// const kBrownColor = Color(0XFF6F4F45);
//
// const kLightBrownColor = Color(0XFFD19C8C);
//
// const kBackgroundLightColor = Color(0XFFFEAC97);
// const kRustyPinkColor = Color(0XFF9e616b);
