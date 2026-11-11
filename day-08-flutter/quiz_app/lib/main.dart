import 'package:flutter/material.dart';

import 'quiz.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3949AB), // deep indigo
      brightness: Brightness.light,
    );
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Quiz App',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A short mix of general knowledge and computer science '
                'questions. Pick an answer for each one and see how '
                'you do at the end.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const QuizScreen()),
                  );
                },
                child: Text('Start quiz (${quizQuestions.length} questions)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizEngine _engine = QuizEngine(quizQuestions);

  void _onOptionTapped(int index) {
    setState(() => _engine.answer(index));
  }

  void _onNext() {
    if (_engine.currentIndex == _engine.totalQuestions - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => ResultScreen(engine: _engine)),
      );
    } else {
      setState(() => _engine.next());
    }
  }

  Color? _optionColor(int index, int? selected) {
    if (selected == null) return null;
    final question = _engine.currentQuestion;
    if (index == question.correctIndex) return Colors.green.shade100;
    if (index == selected) return Colors.red.shade100;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = _engine.currentQuestion;
    final selected = _engine.selectedForCurrent;
    final answered = selected != null;
    final isLast = _engine.currentIndex == _engine.totalQuestions - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${_engine.currentIndex + 1} of '
                '${_engine.totalQuestions}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_engine.currentIndex + 1) / _engine.totalQuestions,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 24),
              Text(
                question.text,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              for (var i = 0; i < question.options.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    color: _optionColor(i, selected),
                    child: ListTile(
                      title: Text(question.options[i]),
                      trailing: selected == i
                          ? Icon(
                              question.isCorrect(i)
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: question.isCorrect(i)
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            )
                          : null,
                      onTap: answered ? null : () => _onOptionTapped(i),
                    ),
                  ),
                ),
              const Spacer(),
              if (answered)
                FilledButton(
                  onPressed: _onNext,
                  child: Text(isLast ? 'See results' : 'Next'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.engine});

  final QuizEngine engine;

  String get _message {
    final score = engine.score;
    final total = engine.totalQuestions;
    if (score == total) return 'Perfect score. Excellent work.';
    if (score >= total * 0.7) return 'Well done, a strong result.';
    if (score >= total * 0.4) {
      return 'Not bad — a bit more practice will help.';
    }
    return 'Keep practicing, you will get there.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'You scored ${engine.score} out of ${engine.totalQuestions}',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  engine.restart();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const StartScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Restart quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
