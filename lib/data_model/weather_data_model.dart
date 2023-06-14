class WeatherDataModel {
  const WeatherDataModel(
      {this.cityName = "",
      this.mainTemp = 0.0,
      this.tempMin = 0.0,
      this.tempMax = 0.0,
      this.weatherDescription = ""});

  final String cityName, weatherDescription;

  ///Using num and not double to avoid int and double mismatch
  final num mainTemp, tempMin, tempMax;
}
