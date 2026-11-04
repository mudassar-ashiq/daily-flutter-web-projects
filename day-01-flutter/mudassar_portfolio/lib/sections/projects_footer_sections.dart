import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme.dart';
import '../widgets/section_widgets.dart';
import 'hero_section.dart' show openGitHub;

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, required this.layout});

  final PortfolioLayout layout;

  @override
  Widget build(BuildContext context) {
    final cards = projects.map((p) => _ProjectCard(project: p)).toList();

    return SectionContainer(
      layout: layout,
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(eyebrow: 'Projects', title: 'Featured Projects'),
          const SizedBox(height: 12),
          Text(
            'Two apps I have built so far.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          if (layout == PortfolioLayout.desktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 24),
                Expanded(child: cards[1]),
              ],
            )
          else
            Column(children: [cards[0], const SizedBox(height: 24), cards[1]]),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project.tagline,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9FB4D8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                for (final point in project.highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle,
                            size: 17,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 14.5,
                              height: 1.45,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tech in project.tech) TechTag(label: tech),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.layout});

  final PortfolioLayout layout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidthFor(layout)),
          child: Column(
            children: [
              const Text(
                'Contact',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'See my code, projects and daily Flutter work on GitHub:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFFC9D6EA)),
              ),
              const SizedBox(height: 8),
              const SelectableText(
                githubUrl,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: openGitHub,
                icon: const Icon(Icons.code, size: 20),
                label: const Text('github.com/mudassar-ashiq'),
              ),
              const SizedBox(height: 36),
              const Divider(color: Color(0xFF2A4470), height: 1),
              const SizedBox(height: 20),
              const Text(
                '© 2026 Mudassar Ashiq  •  Flutter Developer  •  '
                'Sahiwal, Punjab, Pakistan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, color: Color(0xFF8FA3C4)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Built with Flutter & Dart — Day 1 of my daily project series.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF8FA3C4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
