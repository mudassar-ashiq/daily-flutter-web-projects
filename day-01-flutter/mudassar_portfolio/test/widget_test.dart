import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mudassar_portfolio/data/portfolio_data.dart';
import 'package:mudassar_portfolio/main.dart';

void main() {
  group('layout logic', () {
    test('widths map to the right layout', () {
      expect(layoutForWidth(360), PortfolioLayout.mobile);
      expect(layoutForWidth(639), PortfolioLayout.mobile);
      expect(layoutForWidth(640), PortfolioLayout.tablet);
      expect(layoutForWidth(1023), PortfolioLayout.tablet);
      expect(layoutForWidth(1024), PortfolioLayout.desktop);
      expect(layoutForWidth(1600), PortfolioLayout.desktop);
    });

    test('content width is capped on desktop and open on mobile', () {
      expect(contentWidthFor(PortfolioLayout.desktop), 1140);
      expect(contentWidthFor(PortfolioLayout.mobile), double.infinity);
    });

    test('portfolio data is complete', () {
      expect(skills, isNotEmpty);
      expect(projects, hasLength(2));
      expect(projects.first.title, 'Riphah University Portal');
      expect(projects.last.title, 'ShopEase');
      expect(githubUrl, 'https://github.com/mudassar-ashiq');
    });
  });

  testWidgets('portfolio renders name, hero and projects on desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    // Hero shows the name and role.
    expect(find.text('Mudassar Ashiq'), findsWidgets);
    expect(find.text('View my GitHub'), findsOneWidget);

    // Sections exist in the page.
    expect(find.text('About Me'), findsWidgets);
    expect(find.text('Featured Projects'), findsWidgets);
    expect(find.text('Riphah University Portal'), findsWidgets);
    expect(find.text('ShopEase'), findsWidgets);
  });

  testWidgets('portfolio renders stacked on a narrow mobile width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pumpAndSettle();

    expect(find.text('Mudassar Ashiq'), findsWidgets);
    expect(find.text('View my GitHub'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
