import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';
import 'package:quiz_app/quiz.dart';

void main() {
  testWidgets('start screen renders with title and start button', (
    tester,
  ) async {
    await tester.pumpWidget(const QuizApp());

    expect(find.text('Quiz App'), findsOneWidget);
    expect(
      find.text('Start quiz (${quizQuestions.length} questions)'),
      findsOneWidget,
    );
  });

  testWidgets('tapping Start shows the first question', (tester) async {
    await tester.pumpWidget(const QuizApp());

    await tester.tap(
      find.text('Start quiz (${quizQuestions.length} questions)'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of ${quizQuestions.length}'), findsOneWidget);
    expect(find.text(quizQuestions.first.text), findsOneWidget);
    for (final option in quizQuestions.first.options) {
      expect(find.text(option), findsOneWidget);
    }
  });

  testWidgets('answering a question reveals the Next button', (tester) async {
    await tester.pumpWidget(const QuizApp());

    await tester.tap(
      find.text('Start quiz (${quizQuestions.length} questions)'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(quizQuestions.first.options[0]));
    await tester.pumpAndSettle();

    expect(find.text('Next'), findsOneWidget);
  });
}
