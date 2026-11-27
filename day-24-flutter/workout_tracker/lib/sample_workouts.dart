import 'models.dart';

// A few workouts so the app doesn't start empty.
List<Workout> sampleWorkouts() {
  final today = DateTime.now();
  final day = DateTime(today.year, today.month, today.day);
  return [
    Workout(
      name: 'Chest day',
      date: day,
      exercises: [
        Exercise(name: 'Bench press', sets: 4, reps: 8, weightKg: 60),
        Exercise(
          name: 'Incline dumbbell press',
          sets: 3,
          reps: 10,
          weightKg: 20,
        ),
        Exercise(name: 'Push-ups', sets: 3, reps: 15, weightKg: 0),
      ],
    ),
    Workout(
      name: 'Leg day',
      date: day.subtract(const Duration(days: 2)),
      exercises: [
        Exercise(name: 'Squats', sets: 4, reps: 8, weightKg: 70),
        Exercise(name: 'Leg press', sets: 3, reps: 12, weightKg: 90),
        Exercise(name: 'Calf raises', sets: 4, reps: 15, weightKg: 40),
      ],
    ),
    Workout(
      name: 'Back and arms',
      date: day.subtract(const Duration(days: 4)),
      exercises: [
        Exercise(name: 'Pull-ups', sets: 4, reps: 8, weightKg: 0),
        Exercise(name: 'Barbell row', sets: 4, reps: 10, weightKg: 50),
        Exercise(name: 'Bicep curls', sets: 3, reps: 12, weightKg: 12),
      ],
    ),
  ];
}
