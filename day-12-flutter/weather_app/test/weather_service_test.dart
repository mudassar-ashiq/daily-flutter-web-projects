import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/services/weather_service.dart';

void main() {
  group('WeatherService', () {
    test('returns weather for a known city', () async {
      final service = WeatherService(delay: Duration.zero);

      final weather = await service.fetchWeather('Lahore');

      expect(weather.city, 'Lahore');
      expect(weather.daily.length, 5);
    });

    test('throws for an unknown city', () async {
      final service = WeatherService(delay: Duration.zero);

      expect(
        () => service.fetchWeather('London'),
        throwsA(isA<UnknownCityException>()),
      );
    });

    test('lists the five sample cities', () {
      final service = WeatherService(delay: Duration.zero);

      expect(service.cities, [
        'Sahiwal',
        'Lahore',
        'Karachi',
        'Islamabad',
        'Murree',
      ]);
    });
  });
}
