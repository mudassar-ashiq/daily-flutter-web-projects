import 'package:bmi_calculator/bmi.dart';
import 'package:bmi_calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BMI for 70 kg at 175 cm is about 22.9', () {
    expect(calculateBmi(weightKg: 70, heightCm: 175), closeTo(22.86, 0.01));
  });

  test('categories cover the usual boundaries', () {
    expect(bmiCategory(17.0), 'Underweight');
    expect(bmiCategory(22.0), 'Healthy');
    expect(bmiCategory(27.0), 'Overweight');
    expect(bmiCategory(32.0), 'Obese');
  });

  test('zero or negative input is rejected', () {
    expect(() => calculateBmi(weightKg: 70, heightCm: 0), throwsArgumentError);
  });

  testWidgets('entering height and weight shows a BMI result', (tester) async {
    await tester.pumpWidget(const BmiApp());
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Height (cm)').first,
      '175',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Weight (kg)').first,
      '70',
    );
    await tester.tap(find.text('Calculate BMI'));
    await tester.pump();
    expect(find.text('22.9'), findsOneWidget);
    expect(find.text('Healthy'), findsWidgets);
  });
}
