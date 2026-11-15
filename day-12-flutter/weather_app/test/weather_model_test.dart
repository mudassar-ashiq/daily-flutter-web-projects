import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/data/sample_data.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather.fromJson', () {
    test('parses all fields from the sample data', () {
      final weather = Weather.fromJson(sampleWeatherJson['Sahiwal']!);

      expect(weather.city, 'Sahiwal');
      expect(weather.country, 'Pakistan');
      expect(weather.temperatureC, 24);
      expect(weather.feelsLikeC, 25);
      expect(weather.condition, WeatherCondition.haze);
      expect(weather.humidity, 48);
      expect(weather.windKph, 9);
      expect(weather.pressureHpa, 1016);
      expect(weather.hourly.length, 6);
      expect(weather.daily.length, 5);
    });

    test('hourly and daily items parse their own fields', () {
      final weather = Weather.fromJson(sampleWeatherJson['Murree']!);

      expect(weather.hourly.first.hour, '9 AM');
      expect(weather.hourly.first.temperatureC, 7);
      expect(weather.daily[2].day, 'Tue');
      expect(weather.daily[2].condition, WeatherCondition.snow);
      expect(weather.daily[2].lowC, 0);
    });

    test('toJson round-trips back to the same values', () {
      final weather = Weather.fromJson(sampleWeatherJson['Karachi']!);
      final restored = Weather.fromJson(weather.toJson());

      expect(restored.city, weather.city);
      expect(restored.temperatureC, weather.temperatureC);
      expect(restored.condition, weather.condition);
      expect(restored.hourly.length, weather.hourly.length);
      expect(restored.daily.last.day, weather.daily.last.day);
    });
  });

  group('temperature conversion', () {
    test('0°C is 32°F and 100°C is 212°F', () {
      expect(Weather.toFahrenheit(0), 32);
      expect(Weather.toFahrenheit(100), 212);
    });

    test('24°C is about 75°F', () {
      expect(Weather.toFahrenheit(24), closeTo(75.2, 0.01));
    });
  });

  group('high and low', () {
    test('high and low come from the daily forecast', () {
      final weather = Weather.fromJson(sampleWeatherJson['Sahiwal']!);

      expect(weather.highC, 28);
      expect(weather.lowC, 11);
    });
  });

  test('unknown condition strings fall back to clear', () {
    expect(conditionFromString('foggy'), WeatherCondition.clear);
    expect(conditionLabel(WeatherCondition.rain), 'Rain');
  });
}
