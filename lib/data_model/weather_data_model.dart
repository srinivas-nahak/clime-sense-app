class WeatherDataModel {
  const WeatherDataModel(
      {required this.cityName,
      this.mainTemp = 0.0,
      required this.tempMin,
      required this.tempMax,
      required this.weatherDescription});

  final String cityName, weatherDescription;
  final double mainTemp, tempMin, tempMax;
}
