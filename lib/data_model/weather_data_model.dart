class WeatherDataModel {
  const WeatherDataModel(
      {this.cityName = "",
      this.mainTemp = 0.0,
      this.tempMin = 0.0,
      this.tempMax = 0.0,
      this.iconUri = "02d",
      this.seaLevel = 0.0,
      this.humidity = 0.0,
      this.windSpeed = 0.0,
      this.weatherDescription = ""});

  final String cityName, weatherDescription, iconUri;

  ///Using num and not double to avoid int and double mismatch
  final num mainTemp, tempMin, tempMax, seaLevel, humidity, windSpeed;
}
