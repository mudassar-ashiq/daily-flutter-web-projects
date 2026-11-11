import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme.dart';
import '../widgets/section_widgets.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.layout});

  final PortfolioLayout layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionContainer(
      layout: layout,
      background: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(eyebrow: 'About', title: 'About Me'),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              'I am a BS Software Engineering student in my 5th semester '
              'at Riphah International University, Sahiwal Campus '
              '(Faculty of Computing and Innovation), based in Sahiwal, '
              'Punjab, Pakistan. My focus is Flutter development: I '
              'design and build complete apps — login, cloud data, '
              'live maps — and I try to keep the design simple and '
              'easy to use. MoneyGods Transport, a goods-transport '
              'app with Admin, Driver and Customer panels, is the '
              'biggest project I have built so far.',
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: const [
              _StatCard(value: '5th', label: 'Semester — BSSE'),
              _StatCard(value: '2', label: 'Featured Projects'),
              _StatCard(value: '3', label: 'Platforms — Android, iOS, Web'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, required this.layout});

  final PortfolioLayout layout;

  @override
  Widget build(BuildContext context) {
    final columns = switch (layout) {
      PortfolioLayout.desktop => 5,
      PortfolioLayout.tablet => 3,
      PortfolioLayout.mobile => 2,
    };
    // Narrow cards wrap skill names onto two lines, so they need
    // more height than the wide ones.
    final cardHeight = layout == PortfolioLayout.mobile ? 178.0 : 150.0;

    return SectionContainer(
      layout: layout,
      background: AppColors.lightGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(eyebrow: 'Skills', title: 'What I Work With'),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: cardHeight,
            ),
            itemCount: skills.length,
            itemBuilder: (context, index) => _SkillCard(skill: skills[index]),
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.greenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check, size: 19, color: AppColors.green),
            ),
            const SizedBox(height: 12),
            Text(
              skill.name,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                skill.detail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
