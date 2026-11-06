# BMI Calculator

A simple BMI calculator. Enter your height in centimetres and your weight
in kilograms, and it shows your BMI, the category it falls in, and a short note.

## Features

- Height and weight input with basic validation
- BMI result rounded to one decimal place
- Category (Underweight, Healthy, Overweight, Obese) with a short note
- List of the usual BMI categories for reference
- Reset button to clear the form

## How to run it

```
flutter pub get
flutter run
```

## What I practised

- Splitting the calculation logic out of the UI into `lib/bmi.dart`
- Form validation with a `Form` and `TextFormField`
- Unit tests for the calculation and a widget test for the result screen

BMI is only a rough guide. It does not account for muscle mass, age, or
other health factors.
