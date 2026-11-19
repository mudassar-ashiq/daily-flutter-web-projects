import 'dart:convert';

/// One habit and the days it was done.
///
/// Dates are stored as plain 'yyyy-MM-dd' strings so the model stays
/// easy to save as JSON and easy to test without any plugins.
class Habit {
  Habit({
    required this.id,
    required this.name,
    required this.color,
    required this.targetDays,
    required this.created,
    Set<String>? doneDates,
  }) : doneDates = doneDates ?? <String>{};

  final String id;
  String name;
  int color;
  int targetDays;
  final DateTime created;
  final Set<String> doneDates;

  static String dateKey(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final month = d.month.toString().padLeft(2, '0');
    final dayOfMonth = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$dayOfMonth';
  }

  bool isDoneOn(DateTime day) => doneDates.contains(dateKey(day));

  void toggle(DateTime day) {
    final key = dateKey(day);
    if (doneDates.contains(key)) {
      doneDates.remove(key);
    } else {
      doneDates.add(key);
    }
  }

  /// Days in a row ending today (or yesterday, if today isn't done yet).
  int currentStreak({DateTime? now}) {
    var day = DateTime.now();
    if (now != null) day = now;
    day = DateTime(day.year, day.month, day.day);
    if (!isDoneOn(day)) {
      day = day.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (isDoneOn(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// The seven dates of the week containing [now], Monday first.
  static List<DateTime> weekDates({DateTime? now}) {
    final today = now ?? DateTime.now();
    final day = DateTime(today.year, today.month, today.day);
    final monday = day.subtract(Duration(days: day.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  int doneThisWeek({DateTime? now}) {
    var count = 0;
    for (final day in weekDates(now: now)) {
      if (isDoneOn(day)) count++;
    }
    return count;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'targetDays': targetDays,
    'created': created.toIso8601String(),
    'doneDates': doneDates.toList(),
  };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as int,
      targetDays: json['targetDays'] as int,
      created: DateTime.parse(json['created'] as String),
      doneDates: Set<String>.from(json['doneDates'] as List),
    );
  }

  static String encodeList(List<Habit> habits) =>
      jsonEncode(habits.map((h) => h.toJson()).toList());

  static List<Habit> decodeList(String raw) {
    final list = jsonDecode(raw) as List;
    return list
        .map((item) => Habit.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
