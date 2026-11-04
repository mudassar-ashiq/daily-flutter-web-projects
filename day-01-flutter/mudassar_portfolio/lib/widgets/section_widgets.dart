import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme.dart';

// Centres a section and stops it getting too wide on big screens.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.layout,
    required this.child,
    this.background = Colors.white,
    this.verticalPadding = 72,
  });

  final PortfolioLayout layout;
  final Widget child;
  final Color background;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final horizontal = layout == PortfolioLayout.mobile ? 20.0 : 32.0;
    return Container(
      color: background,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidthFor(layout)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontal),
            child: child,
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 28, height: 3, color: AppColors.green),
            const SizedBox(width: 10),
            Text(eyebrow.toUpperCase(), style: theme.textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: 12),
        Text(title, style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

class TechTag extends StatelessWidget {
  const TechTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),
      ),
    );
  }
}
