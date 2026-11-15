import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/services/weather_service.dart';

// The home screen is a scrolling list, so the tests use a tall surface
// to make sure the hourly strip and the forecast are built.
Future<void> pumpHome(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: WeatherHomePage(service: WeatherService(delay: Duration.zero)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the first city weather after loading', (tester) async {
    await pumpHome(tester);

    expect(find.text('Sahiwal, Pakistan'), findsOneWidget);
    expect(find.text('24°C'), findsWidgets);
    expect(find.text('Haze'), findsOneWidget);
    expect(find.text('5-day forecast'), findsOneWidget);
  });

  testWidgets('switching to Fahrenheit changes the shown temperature', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.text('°F'));
    await tester.pumpAndSettle();

    expect(find.text('75°F'), findsWidgets);
    expect(find.text('24°C'), findsNothing);
  });

  testWidgets('shows the hourly strip and the forecast days', (tester) async {
    await pumpHome(tester);

    expect(find.text('Hourly'), findsOneWidget);
    expect(find.text('3 PM'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Thu'), findsOneWidget);
  });
}
