/// A single quiz question with four options.
class Question {
  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  final String text;
  final List<String> options;
  final int correctIndex;

  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}

/// Holds the questions for this app: a mix of general knowledge
/// and basic computer science.
const List<Question> quizQuestions = [
  Question(
    text: 'What is the capital of Pakistan?',
    options: ['Karachi', 'Lahore', 'Islamabad', 'Peshawar'],
    correctIndex: 2,
  ),
  Question(
    text: 'Which planet is known as the Red Planet?',
    options: ['Venus', 'Mars', 'Jupiter', 'Mercury'],
    correctIndex: 1,
  ),
  Question(
    text: 'In computing, what does "CPU" stand for?',
    options: [
      'Central Processing Unit',
      'Computer Personal Unit',
      'Central Program Utility',
      'Core Processing Utility',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'How many sides does a hexagon have?',
    options: ['Five', 'Six', 'Seven', 'Eight'],
    correctIndex: 1,
  ),
  Question(
    text: 'Which data structure works on a first-in, first-out basis?',
    options: ['Stack', 'Queue', 'Tree', 'Graph'],
    correctIndex: 1,
  ),
  Question(
    text: 'What is the chemical symbol for gold?',
    options: ['Ag', 'Fe', 'Au', 'Gd'],
    correctIndex: 2,
  ),
  Question(
    text: 'In Dart, which keyword declares a variable that cannot change?',
    options: ['var', 'let', 'static', 'final'],
    correctIndex: 3,
  ),
  Question(
    text: 'Which is the largest ocean on Earth?',
    options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
    correctIndex: 3,
  ),
  Question(
    text: 'What does "HTTP" stand for?',
    options: [
      'HyperText Transfer Protocol',
      'HighText Transfer Protocol',
      'HyperText Transmission Program',
      'Host Transfer Text Protocol',
    ],
    correctIndex: 0,
  ),
  Question(
    text: 'What is 15% of 200?',
    options: ['20', '25', '30', '45'],
    correctIndex: 2,
  ),
];

/// Tracks progress through the quiz: which question we are on,
/// what the user picked, and the final score.
class QuizEngine {
  QuizEngine(this.questions);

  final List<Question> questions;
  final List<int?> _answers = [];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  int get totalQuestions => questions.length;
  Question get currentQuestion => questions[_currentIndex];

  /// True once every question has been answered.
  bool get isFinished => _answers.length >= questions.length;

  /// The option picked for the current question, or null if none yet.
  int? get selectedForCurrent =>
      _currentIndex < _answers.length ? _answers[_currentIndex] : null;

  /// Records an answer for the current question. Picking again before
  /// moving on simply replaces the earlier choice.
  void answer(int optionIndex) {
    if (_currentIndex < _answers.length) {
      _answers[_currentIndex] = optionIndex;
    } else {
      _answers.add(optionIndex);
    }
  }

  /// Moves to the next question. Returns false if the quiz is finished.
  bool next() {
    if (isFinished) return false;
    if (_currentIndex < questions.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  int get score {
    var count = 0;
    for (var i = 0; i < _answers.length; i++) {
      final picked = _answers[i];
      if (picked != null && questions[i].isCorrect(picked)) {
        count++;
      }
    }
    return count;
  }

  void restart() {
    _answers.clear();
    _currentIndex = 0;
  }
}
