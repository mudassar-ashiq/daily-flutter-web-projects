import 'package:flutter/material.dart';

import 'data/portfolio_data.dart';
import 'sections/about_skills_sections.dart';
import 'sections/hero_section.dart';
import 'sections/projects_footer_sections.dart';
import 'theme.dart';

void main() {
  runApp(const PortfolioApp());
}

// Day 1 project: my portfolio website, built with Flutter Web.
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mudassar Ashiq — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: buildPortfolioTheme(),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  Future<void> _scrollTo(GlobalKey key) async {
    final target = key.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layout = layoutForWidth(constraints.maxWidth);
          return Column(
            children: [
              _TopBar(
                layout: layout,
                onAbout: () => _scrollTo(_aboutKey),
                onSkills: () => _scrollTo(_skillsKey),
                onProjects: () => _scrollTo(_projectsKey),
                onContact: () => _scrollTo(_contactKey),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeroSection(layout: layout),
                      KeyedSubtree(
                        key: _aboutKey,
                        child: AboutSection(layout: layout),
                      ),
                      KeyedSubtree(
                        key: _skillsKey,
                        child: SkillsSection(layout: layout),
                      ),
                      KeyedSubtree(
                        key: _projectsKey,
                        child: ProjectsSection(layout: layout),
                      ),
                      KeyedSubtree(
                        key: _contactKey,
                        child: FooterSection(layout: layout),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.layout,
    required this.onAbout,
    required this.onSkills,
    required this.onProjects,
    required this.onContact,
  });

  final PortfolioLayout layout;
  final VoidCallback onAbout;
  final VoidCallback onSkills;
  final VoidCallback onProjects;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final showNav = layout != PortfolioLayout.mobile;
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: showNav ? 32 : 20,
        vertical: 14,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidthFor(layout)),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'MA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mudassar Ashiq',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              if (showNav) ...[
                _NavLink(label: 'About', onTap: onAbout),
                _NavLink(label: 'Skills', onTap: onSkills),
                _NavLink(label: 'Projects', onTap: onProjects),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: onContact,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Contact'),
                ),
              ] else
                IconButton(
                  onPressed: onProjects,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  tooltip: 'Go to Projects',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
