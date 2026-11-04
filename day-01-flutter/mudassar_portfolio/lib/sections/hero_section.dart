import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme.dart';

Future<void> openGitHub() async {
  final uri = Uri.parse(githubUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// Top section: intro text and a small profile card.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.layout});

  final PortfolioLayout layout;

  @override
  Widget build(BuildContext context) {
    final wide = layout != PortfolioLayout.mobile;
    final intro = _Intro(wide: wide);
    final card = _ProfileCard(wide: wide);

    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        vertical: wide ? 84 : 56,
        horizontal: wide ? 32 : 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidthFor(layout)),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: intro),
                    const SizedBox(width: 48),
                    Expanded(flex: 2, child: card),
                  ],
                )
              : Column(children: [intro, const SizedBox(height: 36), card]),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final align = wide ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final textAlign = wide ? TextAlign.start : TextAlign.center;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.green),
          ),
          child: const Text(
            'FLUTTER DEVELOPER  •  BSSE STUDENT',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Mudassar Ashiq',
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 54,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'I\'m a BSSE student and Flutter developer from Sahiwal. '
          'I build mobile apps with Flutter and Dart, using Firebase '
          'for the backend and Google Maps for location features.',
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Color(0xFFC9D6EA),
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          alignment: wide ? WrapAlignment.start : WrapAlignment.center,
          spacing: 14,
          runSpacing: 14,
          children: [
            FilledButton.icon(
              onPressed: openGitHub,
              icon: const Icon(Icons.code, size: 20),
              label: const Text('View my GitHub'),
            ),
            OutlinedButton(
              onPressed: openGitHub,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF5A74A3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(githubHandle),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.navy,
                child: Text(
                  'MA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mudassar Ashiq',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Flutter Developer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _FactRow(
            icon: Icons.school_outlined,
            label: 'BS Software Engineering — 5th Semester',
          ),
          const _FactRow(
            icon: Icons.account_balance_outlined,
            label: 'Riphah International University, Sahiwal',
          ),
          const _FactRow(
            icon: Icons.place_outlined,
            label: 'Sahiwal, Punjab, Pakistan',
            last: true,
          ),
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.icon, required this.label, this.last = false});

  final IconData icon;
  final String label;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
