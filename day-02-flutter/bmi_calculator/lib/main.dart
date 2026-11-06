import 'package:flutter/material.dart';

import 'bmi.dart';

void main() {
  runApp(const BmiApp());
}

class BmiApp extends StatelessWidget {
  const BmiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6B52)),
        useMaterial3: true,
      ),
      home: const BmiHomePage(),
    );
  }
}

class BmiHomePage extends StatefulWidget {
  const BmiHomePage({super.key});

  @override
  State<BmiHomePage> createState() => _BmiHomePageState();
}

class _BmiHomePageState extends State<BmiHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;
  String? _category;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    final height = double.parse(_heightController.text);
    final weight = double.parse(_weightController.text);
    final bmi = calculateBmi(weightKg: weight, heightCm: height);
    setState(() {
      _bmi = bmi;
      _category = bmiCategory(bmi);
    });
  }

  void _reset() {
    _formKey.currentState?.reset();
    _heightController.clear();
    _weightController.clear();
    setState(() {
      _bmi = null;
      _category = null;
    });
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    if (number == null) return 'Enter a number';
    if (number <= 0) return 'Must be greater than zero';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Work out your Body Mass Index',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your height and weight. The result is a rough guide, '
                'not a medical diagnosis.',
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                validator: _positiveNumber,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                validator: _positiveNumber,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _calculate,
                child: const Text('Calculate BMI'),
              ),
              TextButton(onPressed: _reset, child: const Text('Reset')),
              if (_bmi != null && _category != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          _bmi!.toStringAsFixed(1),
                          style: theme.textTheme.displayMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(_category!, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(bmiNote(_category!), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text('Categories'),
              const SizedBox(height: 8),
              const _CategoryRow(label: 'Underweight', range: 'Below 18.5'),
              const _CategoryRow(label: 'Healthy', range: '18.5 – 24.9'),
              const _CategoryRow(label: 'Overweight', range: '25 – 29.9'),
              const _CategoryRow(label: 'Obese', range: '30 and above'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.label, required this.range});

  final String label;
  final String range;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(range)],
      ),
    );
  }
}
