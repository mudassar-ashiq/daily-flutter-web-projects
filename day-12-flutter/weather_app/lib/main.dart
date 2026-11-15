import 'package:flutter/material.dart';

import 'models/weather.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(service: WeatherService()),
    );
  }
}

IconData conditionIcon(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.clear:
      return Icons.wb_sunny_outlined;
    case WeatherCondition.partlyCloudy:
      return Icons.cloud_outlined;
    case WeatherCondition.cloudy:
      return Icons.cloud;
    case WeatherCondition.rain:
      return Icons.umbrella_outlined;
    case WeatherCondition.thunderstorm:
      return Icons.thunderstorm_outlined;
    case WeatherCondition.snow:
      return Icons.ac_unit_outlined;
    case WeatherCondition.haze:
      return Icons.blur_on_outlined;
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, required this.service});

  final WeatherService service;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late String _city;
  late Future<Weather> _weatherFuture;
  bool _useFahrenheit = false;

  @override
  void initState() {
    super.initState();
    _city = widget.service.cities.first;
    _weatherFuture = widget.service.fetchWeather(_city);
  }

  String formatTemp(double celsius) {
    if (_useFahrenheit) {
      return '${Weather.toFahrenheit(celsius).round()}°F';
    }
    return '${celsius.round()}°C';
  }

  void _refresh() {
    setState(() {
      _weatherFuture = widget.service.fetchWeather(_city);
    });
  }

  void _changeCity(String? city) {
    if (city == null || city == _city) return;
    setState(() {
      _city = city;
      _weatherFuture = widget.service.fetchWeather(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('°C')),
              ButtonSegment(value: true, label: Text('°F')),
            ],
            selected: {_useFahrenheit},
            onSelectionChanged: (selected) {
              setState(() => _useFahrenheit = selected.first);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<Weather>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off_outlined, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _refresh,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final weather = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownMenu<String>(
                  initialSelection: _city,
                  dropdownMenuEntries: widget.service.cities
                      .map(
                        (city) => DropdownMenuEntry(value: city, label: city),
                      )
                      .toList(),
                  onSelected: _changeCity,
                  leadingIcon: const Icon(Icons.location_on_outlined),
                  width: 220,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '${weather.city}, ${weather.country}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Updated ${weather.updatedAt.hour}:${weather.updatedAt.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Icon(
                          conditionIcon(weather.condition),
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatTemp(weather.temperatureC),
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(conditionLabel(weather.condition)),
                        const SizedBox(height: 8),
                        Text(
                          'Feels like ${formatTemp(weather.feelsLikeC)}  •  '
                          'High ${formatTemp(weather.highC)}  •  '
                          'Low ${formatTemp(weather.lowC)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _DetailTile(
                      icon: Icons.water_drop_outlined,
                      label: 'Humidity',
                      value: '${weather.humidity}%',
                    ),
                    _DetailTile(
                      icon: Icons.air_outlined,
                      label: 'Wind',
                      value: '${weather.windKph.round()} km/h',
                    ),
                  ],
                ),
                Row(
                  children: [
                    _DetailTile(
                      icon: Icons.speed_outlined,
                      label: 'Pressure',
                      value: '${weather.pressureHpa} hPa',
                    ),
                    _DetailTile(
                      icon: Icons.visibility_outlined,
                      label: 'Visibility',
                      value: '${weather.visibilityKm} km',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Hourly', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: weather.hourly.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final hour = weather.hourly[index];
                      return SizedBox(
                        width: 76,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(hour.hour),
                                const SizedBox(height: 8),
                                Icon(
                                  conditionIcon(hour.condition),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(formatTemp(hour.temperatureC)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '5-day forecast',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: weather.daily.map((day) {
                      return ListTile(
                        leading: Icon(
                          conditionIcon(day.condition),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(day.day),
                        subtitle: Text(conditionLabel(day.condition)),
                        trailing: Text(
                          '${formatTemp(day.highC)} / ${formatTemp(day.lowC)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
