import '../data/sample_data.dart';
import '../models/weather.dart';

class UnknownCityException implements Exception {
  UnknownCityException(this.city);

  final String city;

  @override
  String toString() => 'No weather data for "$city".';
}

class WeatherService {
  const WeatherService({this.delay = const Duration(milliseconds: 600)});

  final Duration delay;

  List<String> get cities => sampleWeatherJson.keys.toList();

  // In a real app this would call a weather API over HTTP. For now it
  // reads the sample data after a short delay, so the loading state
  // in the UI still works the same way.
  Future<Weather> fetchWeather(String city) async {
    await Future.delayed(delay);
    final json = sampleWeatherJson[city];
    if (json == null) {
      throw UnknownCityException(city);
    }
    return Weather.fromJson(json);
  }
}
