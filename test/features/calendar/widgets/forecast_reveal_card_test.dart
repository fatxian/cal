import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar_app/features/calendar/widgets/forecast_reveal_card.dart';

void main() {
  testWidgets('shows missing categories', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ForecastRevealCard(
            hasSuccessfulSync: true,
            hasPrediction: true,
            isLoading: false,
            uncategorizedEventCount: 2,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Review today\'s activities'), findsOneWidget);
    expect(find.text('2 activities need categories'), findsOneWidget);
    expect(find.text('View today\'s forecast'), findsNothing);
  });
}
