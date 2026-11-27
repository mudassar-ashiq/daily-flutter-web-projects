import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/models.dart';

void main() {
  test('exercise volume is sets x reps x weight', () {
    final exercise = Exercise(
      name: 'Bench press',
      sets: 4,
      reps: 8,
      weightKg: 60,
    );
    expect(exercise.volume, 1920);
  });

  test('bodyweight exercise still counts sets and reps', () {
    final exercise = Exercise(name: 'Push-ups', sets: 3, reps: 15, weightKg: 0);
    expect(exercise.volume, 0);
    expect(exercise.summary, '3 x 15  •  0 kg');
  });

  test('workout volume adds up its exercises', () {
    final workout = Workout(
      name: 'Chest day',
      date: DateTime(2026, 11, 27),
      exercises: [
        Exercise(name: 'Bench press', sets: 4, reps: 8, weightKg: 60),
        Exercise(name: 'Push-ups', sets: 3, reps: 15, weightKg: 0),
      ],
    );
    expect(workout.volume, 1920);
    expect(workout.totalSets, 7);
  });

  test('workout survives a JSON round trip', () {
    final workout = Workout(
      name: 'Leg day',
      date: DateTime(2026, 11, 25),
      exercises: [Exercise(name: 'Squats', sets: 4, reps: 8, weightKg: 70)],
    );
    final decoded = Workout.decodeList(Workout.encodeList([workout]));
    expect(decoded.length, 1);
    expect(decoded.first.name, 'Leg day');
    expect(decoded.first.date, DateTime(2026, 11, 25));
    expect(decoded.first.exercises.first.name, 'Squats');
    expect(decoded.first.volume, 2240);
  });

  test('week summary only counts the last 7 days', () {
    final now = DateTime(2026, 11, 27);
    final workouts = [
      Workout(
        name: 'Today',
        date: DateTime(2026, 11, 27),
        exercises: [Exercise(name: 'Squats', sets: 2, reps: 10, weightKg: 50)],
      ),
      Workout(
        name: 'Three days ago',
        date: DateTime(2026, 11, 24),
        exercises: [Exercise(name: 'Squats', sets: 1, reps: 10, weightKg: 50)],
      ),
      Workout(
        name: 'Ten days ago',
        date: DateTime(2026, 11, 17),
        exercises: [Exercise(name: 'Squats', sets: 1, reps: 10, weightKg: 50)],
      ),
    ];
    final summary = weekSummary(workouts, now: now);
    expect(summary.workoutCount, 2);
    expect(summary.volume, 1500);
  });

  test('dates format as day month year', () {
    expect(formatDate(DateTime(2026, 11, 27)), '27 Nov 2026');
  });
}
