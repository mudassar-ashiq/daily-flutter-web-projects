// The text and data shown on the page, plus the layout breakpoints.
// No widgets in here, which makes it easy to test.
library;

enum PortfolioLayout { mobile, tablet, desktop }

// Under 640 is mobile, 640 to 1023 is tablet, 1024 and up is desktop.
PortfolioLayout layoutForWidth(double width) {
  if (width >= 1024) return PortfolioLayout.desktop;
  if (width >= 640) return PortfolioLayout.tablet;
  return PortfolioLayout.mobile;
}

double contentWidthFor(PortfolioLayout layout) => switch (layout) {
  PortfolioLayout.desktop => 1140,
  PortfolioLayout.tablet => 860,
  PortfolioLayout.mobile => double.infinity,
};

class Skill {
  const Skill(this.name, this.detail);

  final String name;
  final String detail;
}

const List<Skill> skills = [
  Skill('Flutter', 'Cross-platform apps for Android, iOS and Web'),
  Skill('Dart', 'The language behind every Flutter app I build'),
  Skill('Firebase', 'Auth, Cloud Firestore, Storage and FCM'),
  Skill('Riverpod', 'State management I use in my apps'),
  Skill('GoRouter', 'Declarative navigation and deep links'),
  Skill('Google Maps', 'Maps, live GPS tracking and location'),
  Skill('Clean Architecture', 'Keeping the code organised in layers'),
  Skill('Material 3 UI/UX', 'Design system for my app interfaces'),
  Skill('Python', 'Scripting and university coursework'),
  Skill('HTML / CSS', 'The foundations of the web'),
];

class Project {
  const Project({
    required this.title,
    required this.tagline,
    required this.description,
    required this.highlights,
    required this.tech,
  });

  final String title;
  final String tagline;
  final String description;
  final List<String> highlights;
  final List<String> tech;
}

const List<Project> projects = [
  Project(
    title: 'MoneyGods Transport',
    tagline: 'Goods transport app — Flutter & Firebase',
    description:
        'A complete goods transport app for Mudassar and Mubashir '
        'MoneyGods Transport Company, with separate Admin, Driver and '
        'Customer panels, live trip tracking and a transparent fare '
        'system.',
    highlights: [
      'Admin, Driver and Customer panels with role-based routing',
      'Live GPS tracking on Google Maps during active trips',
      'Fare = distance (KM) × vehicle rate + diesel-price adjustment',
      'Vehicle categories: Pickup, Shahzor, Mazda and 10 Wheeler',
    ],
    tech: ['Flutter', 'Firebase', 'Riverpod', 'GoRouter', 'Google Maps'],
  ),
  Project(
    title: 'ShopEase',
    tagline: 'Shopping app — CS-436 Mobile App Development',
    description:
        'A three-screen Flutter shopping app built for a university '
        'lab assessment, covering the full flow from login to a '
        'priced-up product order.',
    highlights: [
      'Login screen with name, email and password validation',
      'Personalised product landing screen',
      'Product details with quantity picker and live total price',
    ],
    tech: ['Flutter', 'Dart', 'Material 3', 'Form Validation'],
  ),
];

const String githubUrl = 'https://github.com/mudassar-ashiq';
const String githubHandle = 'github.com/mudassar-ashiq';
