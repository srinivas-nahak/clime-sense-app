import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_practice/screens/weather_screen.dart';
import 'package:weather_practice/utilities/constants.dart';
import 'package:weather_practice/utilities/custome_page_route.dart';

import '../provider/weather_data_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isInvisible = false;

  @override
  void initState() {
    //Fetching the current location's weather data
    ref.read(weatherDataProvider.notifier).fetchCurrentLocationWeather();

    // Timer(const Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const WeatherScreen(),
    //     ),
    //   );
    // });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isInvisible = true;
      });
    });

    super.initState();
  }

  void _showWeather() {
    Navigator.pushReplacement(
      context,
      CustomPageRoute(child: const WeatherScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 1600),
        opacity: _isInvisible ? 0.1 : 0.8,
        curve: Curves.easeInOut,
        onEnd: _showWeather,
        child: Center(
          child: SvgPicture.asset(
            kWeatherIconSet[kWeatherIconName.appIcon]!,
            width: 200,
          ),
        ),
      ),
    );
  }
}

// AnimatedContainer(
// duration: const Duration(seconds: 2),
// curve: Curves.easeInOut,
// transform: _isScaled
// ? (Matrix4.identity()..scale(2.0, 2.0, 2.0))
//     : Matrix4.identity(),
// child: Opacity(
// opacity: 0.8,
// child: SvgPicture.asset(
// kWeatherIconSet[kWeatherIconName.cloudySunny]!,
// width: 200,
// ),
// ),
// onEnd: () => print("Wowwhoooo"),
// ),
