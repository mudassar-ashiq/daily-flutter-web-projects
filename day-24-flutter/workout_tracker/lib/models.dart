import 'dart:convert';

class Exercise {
  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weightKg,
  });

  final String name;
  final int sets;
  final int reps;
  final double weightKg;

  // Total weight moved for this exercise: sets x reps x weight.
  double get volume => sets * reps * weightKg;

  String get summary {
    final weight = weightKg == weightKg.truncateToDouble()
        ? weightKg.toInt().toString()
        : weightKg.toString();
    return '$sets x $reps  •  $weight kg';
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'sets': sets,
    'reps': reps,
    'weightKg': weightKg,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'] as String,
    sets: json['sets'] as int,
    reps: json['reps'] as int,
    weightKg: (json['weightKg'] as num).toDouble(),
  );
}

class Workout {
  Workout({required this.name, required this.date, required this.exercises});

  final String name;
  final DateTime date;
  final List<Exercise> exercises;

  double get volume => exercises.fold(0, (sum, e) => sum + e.volume);

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date.toIso8601String(),
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    name: json['name'] as String,
    date: DateTime.parse(json['date'] as String),
    exercises: (json['exercises'] as List)
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  static String encodeList(List<Workout> workouts) =>
      jsonEncode(workouts.map((w) => w.toJson()).toList());

  static List<Workout> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((w) => Workout.fromJson(w as Map<String, dynamic>))
        .toList();
  }
}

class WeekSummary {
  WeekSummary({required this.workoutCount, required this.volume});

  final int workoutCount;
  final double volume;
}

// Workouts from the last 7 days, newest first in the list.
WeekSummary weekSummary(List<Workout> workouts, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final weekAgo = today.subtract(const Duration(days: 7));
  final recent = workouts.where((w) => w.date.isAfter(weekAgo)).toList();
  return WeekSummary(
    workoutCount: recent.length,
    volume: recent.fold(0, (sum, w) => sum + w.volume),
  );
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatKg(double kg) {
  if (kg == kg.truncateToDouble()) return kg.toInt().toString();
  return kg.toStringAsFixed(1);
}
