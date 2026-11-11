import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/quiz.dart';

List<Question> sampleQuestions() => const [
  Question(text: 'First?', options: ['a', 'b', 'c', 'd'], correctIndex: 1),
  Question(text: 'Second?', options: ['a', 'b', 'c', 'd'], correctIndex: 0),
  Question(text: 'Third?', options: ['a', 'b', 'c', 'd'], correctIndex: 3),
];

void main() {
  group('QuizEngine', () {
    test('starts at the first question with no answer selected', () {
      final engine = QuizEngine(sampleQuestions());
      expect(engine.currentIndex, 0);
      expect(engine.selectedForCurrent, isNull);
      expect(engine.isFinished, isFalse);
      expect(engine.score, 0);
    });

    test('scores a correct answer', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(1); // correct index for question 1
      expect(engine.score, 1);
    });

    test('does not score a wrong answer', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(0); // wrong for question 1
      expect(engine.score, 0);
    });

    test('changing an answer before moving on replaces the old one', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(0);
      engine.answer(1);
      expect(engine.selectedForCurrent, 1);
      expect(engine.score, 1);
    });

    test('next advances to the following question', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(1);
      expect(engine.next(), isTrue);
      expect(engine.currentIndex, 1);
      expect(engine.currentQuestion.text, 'Second?');
    });

    test('isFinished after every question is answered', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(1);
      engine.next();
      engine.answer(0);
      engine.next();
      engine.answer(3);
      expect(engine.isFinished, isTrue);
      expect(engine.score, 3);
    });

    test('mixed answers give a partial score', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(1); // right
      engine.next();
      engine.answer(2); // wrong (correct is 0)
      engine.next();
      engine.answer(3); // right
      expect(engine.score, 2);
    });

    test('restart resets index, answers and score', () {
      final engine = QuizEngine(sampleQuestions());
      engine.answer(1);
      engine.next();
      engine.answer(0);
      engine.restart();
      expect(engine.currentIndex, 0);
      expect(engine.selectedForCurrent, isNull);
      expect(engine.isFinished, isFalse);
      expect(engine.score, 0);
    });
  });

  group('Question data', () {
    test('the app quiz has 10 questions with 4 options each', () {
      expect(quizQuestions, hasLength(10));
      for (final q in quizQuestions) {
        expect(q.options, hasLength(4));
        expect(q.correctIndex, inInclusiveRange(0, 3));
      }
    });
  });
}
