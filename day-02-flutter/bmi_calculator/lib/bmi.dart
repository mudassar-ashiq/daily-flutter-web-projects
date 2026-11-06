double calculateBmi({required double weightKg, required double heightCm}) {
  if (weightKg <= 0 || heightCm <= 0) {
    throw ArgumentError('Weight and height must be greater than zero.');
  }
  final heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

String bmiCategory(double bmi) {
  if (bmi < 18.5) return 'Underweight';
  if (bmi < 25) return 'Healthy';
  if (bmi < 30) return 'Overweight';
  return 'Obese';
}

String bmiNote(String category) {
  switch (category) {
    case 'Underweight':
      return 'Below the healthy range. Eating a little more, regularly, can help.';
    case 'Healthy':
      return 'Inside the healthy range. Keep up whatever is working.';
    case 'Overweight':
      return 'Above the healthy range. Small, steady changes tend to stick.';
    case 'Obese':
      return 'Well above the healthy range. Worth talking to a doctor about next steps.';
    default:
      return '';
  }
}
