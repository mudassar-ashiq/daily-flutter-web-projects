# Weather App

Day 12 of my daily project series — a simple weather app built with Flutter and Dart.

It shows the current weather, an hourly strip and a five day forecast
for five cities in Pakistan. The data is sample data in the same shape
a weather API returns, so the app works without an API key.

## Features

- Pick a city from the list (Sahiwal, Lahore, Karachi, Islamabad, Murree)
- Current temperature, condition, feels-like, high and low
- Humidity, wind speed, pressure and visibility
- Hourly forecast strip and a 5-day forecast list
- Switch between °C and °F
- Pull down to refresh

## How to run

```
flutter pub get
flutter run
```

## Tests

```
flutter test
```

## What I practised

- Writing data models with `fromJson` and `toJson` (`lib/models/weather.dart`)
- Keeping the weather data separate from the UI, in the same shape an
  API response would have (`lib/data/sample_data.dart`)
- A small service class that loads data and throws a clear error for an
  unknown city (`lib/services/weather_service.dart`)
- Loading states with `FutureBuilder`, pull-to-refresh and a °C/°F switch
- Unit tests for the models and the service, and widget tests for the
  home screen
