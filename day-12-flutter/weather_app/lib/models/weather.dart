enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  rain,
  thunderstorm,
  snow,
  haze,
}

WeatherCondition conditionFromString(String value) {
  switch (value) {
    case 'clear':
      return WeatherCondition.clear;
    case 'partly_cloudy':
      return WeatherCondition.partlyCloudy;
    case 'cloudy':
      return WeatherCondition.cloudy;
    case 'rain':
      return WeatherCondition.rain;
    case 'thunderstorm':
      return WeatherCondition.thunderstorm;
    case 'snow':
      return WeatherCondition.snow;
    case 'haze':
      return WeatherCondition.haze;
    default:
      return WeatherCondition.clear;
  }
}

String conditionToString(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.clear:
      return 'clear';
    case WeatherCondition.partlyCloudy:
      return 'partly_cloudy';
    case WeatherCondition.cloudy:
      return 'cloudy';
    case WeatherCondition.rain:
      return 'rain';
    case WeatherCondition.thunderstorm:
      return 'thunderstorm';
    case WeatherCondition.snow:
      return 'snow';
    case WeatherCondition.haze:
      return 'haze';
  }
}

String conditionLabel(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.clear:
      return 'Clear sky';
    case WeatherCondition.partlyCloudy:
      return 'Partly cloudy';
    case WeatherCondition.cloudy:
      return 'Cloudy';
    case WeatherCondition.rain:
      return 'Rain';
    case WeatherCondition.thunderstorm:
      return 'Thunderstorm';
    case WeatherCondition.snow:
      return 'Snow';
    case WeatherCondition.haze:
      return 'Haze';
  }
}

class HourlyForecast {
  const HourlyForecast({
    required this.hour,
    required this.temperatureC,
    required this.condition,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      hour: json['hour'] as String,
      temperatureC: (json['temp_c'] as num).toDouble(),
      condition: conditionFromString(json['condition'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'temp_c': temperatureC,
    'condition': conditionToString(condition),
  };

  final String hour;
  final double temperatureC;
  final WeatherCondition condition;
}

class DailyForecast {
  const DailyForecast({
    required this.day,
    required this.highC,
    required this.lowC,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      day: json['day'] as String,
      highC: (json['high_c'] as num).toDouble(),
      lowC: (json['low_c'] as num).toDouble(),
      condition: conditionFromString(json['condition'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'high_c': highC,
    'low_c': lowC,
    'condition': conditionToString(condition),
  };

  final String day;
  final double highC;
  final double lowC;
  final WeatherCondition condition;
}

class Weather {
  const Weather({
    required this.city,
    required this.country,
    required this.temperatureC,
    required this.feelsLikeC,
    required this.condition,
    required this.humidity,
    required this.windKph,
    required this.pressureHpa,
    required this.visibilityKm,
    required this.hourly,
    required this.daily,
    required this.updatedAt,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'] as String,
      country: json['country'] as String,
      temperatureC: (json['temp_c'] as num).toDouble(),
      feelsLikeC: (json['feels_like_c'] as num).toDouble(),
      condition: conditionFromString(json['condition'] as String),
      humidity: json['humidity'] as int,
      windKph: (json['wind_kph'] as num).toDouble(),
      pressureHpa: json['pressure_hpa'] as int,
      visibilityKm: (json['visibility_km'] as num).toDouble(),
      hourly: (json['hourly'] as List)
          .map((item) => HourlyForecast.fromJson(item as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List)
          .map((item) => DailyForecast.fromJson(item as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'country': country,
    'temp_c': temperatureC,
    'feels_like_c': feelsLikeC,
    'condition': conditionToString(condition),
    'humidity': humidity,
    'wind_kph': windKph,
    'pressure_hpa': pressureHpa,
    'visibility_km': visibilityKm,
    'hourly': hourly.map((item) => item.toJson()).toList(),
    'daily': daily.map((item) => item.toJson()).toList(),
    'updated_at': updatedAt.toIso8601String(),
  };

  // Convert a Celsius value to Fahrenheit. Kept on the model so the
  // UI and the tests use the same formula.
  static double toFahrenheit(double celsius) => celsius * 9 / 5 + 32;

  double get highC =>
      daily.map((day) => day.highC).reduce((a, b) => a > b ? a : b);
  double get lowC =>
      daily.map((day) => day.lowC).reduce((a, b) => a < b ? a : b);

  final String city;
  final String country;
  final double temperatureC;
  final double feelsLikeC;
  final WeatherCondition condition;
  final int humidity;
  final double windKph;
  final int pressureHpa;
  final double visibilityKm;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final DateTime updatedAt;
}
