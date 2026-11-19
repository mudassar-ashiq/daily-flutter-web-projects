import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/models/habit.dart';

Habit habitWithDoneDays(List<DateTime> days) {
  final habit = Habit(
    id: '1',
    name: 'Read',
    color: 0xFF2E7D5B,
    targetDays: 5,
    created: DateTime(2026, 11, 1),
  );
  for (final day in days) {
    habit.toggle(day);
  }
  return habit;
}

void main() {
  group('Habit toggle', () {
    test('toggling a day marks it done, toggling again undoes it', () {
      final habit = habitWithDoneDays([]);
      final day = DateTime(2026, 11, 19);

      expect(habit.isDoneOn(day), isFalse);
      habit.toggle(day);
      expect(habit.isDoneOn(day), isTrue);
      habit.toggle(day);
      expect(habit.isDoneOn(day), isFalse);
    });

    test('different days are tracked separately', () {
      final habit = habitWithDoneDays([DateTime(2026, 11, 18)]);
      expect(habit.isDoneOn(DateTime(2026, 11, 18)), isTrue);
      expect(habit.isDoneOn(DateTime(2026, 11, 19)), isFalse);
    });
  });

  group('currentStreak', () {
    test('counts consecutive days ending today', () {
      final habit = habitWithDoneDays([
        DateTime(2026, 11, 19),
        DateTime(2026, 11, 18),
        DateTime(2026, 11, 17),
      ]);
      expect(habit.currentStreak(now: DateTime(2026, 11, 19)), 3);
    });

    test('a gap breaks the streak', () {
      final habit = habitWithDoneDays([
        DateTime(2026, 11, 19),
        DateTime(2026, 11, 17),
      ]);
      expect(habit.currentStreak(now: DateTime(2026, 11, 19)), 1);
    });

    test('counts from yesterday when today is not done yet', () {
      final habit = habitWithDoneDays([
        DateTime(2026, 11, 18),
        DateTime(2026, 11, 17),
      ]);
      expect(habit.currentStreak(now: DateTime(2026, 11, 19)), 2);
    });

    test('is zero when nothing is done', () {
      final habit = habitWithDoneDays([]);
      expect(habit.currentStreak(now: DateTime(2026, 11, 19)), 0);
    });
  });

  group('week progress', () {
    test('weekDates starts on Monday', () {
      // 19 Nov 2026 is a Thursday.
      final week = Habit.weekDates(now: DateTime(2026, 11, 19));
      expect(week.length, 7);
      expect(week.first, DateTime(2026, 11, 16));
      expect(week.last, DateTime(2026, 11, 22));
      expect(week.first.weekday, DateTime.monday);
    });

    test('doneThisWeek only counts the current week', () {
      final habit = habitWithDoneDays([
        DateTime(2026, 11, 16), // Monday this week
        DateTime(2026, 11, 18), // Wednesday this week
        DateTime(2026, 11, 15), // Sunday last week
      ]);
      expect(habit.doneThisWeek(now: DateTime(2026, 11, 19)), 2);
    });
  });

  group('JSON round trip', () {
    test('toJson and fromJson keep everything', () {
      final habit = habitWithDoneDays([
        DateTime(2026, 11, 18),
        DateTime(2026, 11, 19),
      ]);
      final restored = Habit.fromJson(habit.toJson());

      expect(restored.id, habit.id);
      expect(restored.name, habit.name);
      expect(restored.color, habit.color);
      expect(restored.targetDays, habit.targetDays);
      expect(restored.doneDates, habit.doneDates);
    });

    test('a list encodes and decodes', () {
      final habits = [
        habitWithDoneDays([DateTime(2026, 11, 19)]),
        Habit(
          id: '2',
          name: 'Run',
          color: 0xFF1565C0,
          targetDays: 3,
          created: DateTime(2026, 11, 2),
        ),
      ];
      final restored = Habit.decodeList(Habit.encodeList(habits));
      expect(restored.length, 2);
      expect(restored.first.name, 'Read');
      expect(restored.last.name, 'Run');
    });
  });
}
