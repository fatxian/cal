import 'package:calendar_app/features/onboarding/screens/onboarding_questionnaire_screen.dart';
import 'package:calendar_app/features/onboarding/models/onboarding_questionnaire_answers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('moves through questions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: OnboardingQuestionnaireScreen()),
    );

    expect(find.text('Question 1 of 11'), findsOneWidget);
    expect(
      find.text(
        'At the end of a typical day, how much energy do you usually have left?',
      ),
      findsOneWidget,
    );
    expect(tester.widget<Slider>(find.byType(Slider)).divisions, 4);
    expect(findAssetImage('assets/images/emoji_3.png'), findsOneWidget);
    expect(tester.widget<Slider>(find.byType(Slider)).padding, EdgeInsets.zero);

    final centres = [
      for (var value = 1; value <= 5; value++)
        tester.getCenter(find.byKey(ValueKey('scale-value-$value'))).dx,
    ];
    final gaps = [
      for (var index = 0; index < centres.length - 1; index++)
        centres[index + 1] - centres[index],
    ];
    for (final gap in gaps.skip(1)) {
      expect(gap, closeTo(gaps.first, 0.01));
    }

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Question 2 of 11'), findsOneWidget);
    expect(
      find.text(
        'When your day includes many hours of scheduled activities, how does that usually affect your energy?',
      ),
      findsOneWidget,
    );
    expect(find.text('Drains my energy'), findsOneWidget);
    expect(find.text('Improves my energy'), findsOneWidget);
    expect(tester.widget<Slider>(find.byType(Slider)).divisions, 4);
    expect(find.text('Back'), findsOneWidget);
  });

  testWidgets('returns questionnaire answers', (tester) async {
    OnboardingQuestionnaireAnswers? savedAnswers;

    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingQuestionnaireScreen(
          onCompleted: (answers) async {
            savedAnswers = answers;
          },
        ),
      ),
    );

    for (var question = 1; question < 11; question++) {
      await tester.tap(find.text('Next'));
      await tester.pump();
    }

    await tester.tap(find.text('Finish'));
    await tester.pump();
    await tester.tap(find.text('Done'));
    await tester.pump();

    expect(savedAnswers, isNotNull);
    expect(savedAnswers!.typicalEnergyScore, 3);
    expect(savedAnswers!.busyImpactScore, 3);
    expect(savedAnswers!.exerciseImpactScore, 3);
    expect(savedAnswers!.schedulePredictionConfidenceScore, 3);
  });

  testWidgets('loads saved answers', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingQuestionnaireScreen(
          initialAnswers: OnboardingQuestionnaireAnswers(
            typicalEnergyScore: 4,
            busyImpactScore: 2,
            backToBackImpactScore: 1,
            longBlockImpactScore: 2,
            freeGapImpactScore: 5,
            focusImpactScore: 2,
            socialImpactScore: 4,
            lifeAdminImpactScore: 2,
            exerciseImpactScore: 5,
            calendarUnderstandingScore: 3,
            schedulePredictionConfidenceScore: 3,
          ),
        ),
      ),
    );

    expect(tester.widget<Slider>(find.byType(Slider)).value, 4);
    expect(findAssetImage('assets/images/emoji_4.png'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(tester.widget<Slider>(find.byType(Slider)).value, 2);
  });
}

Finder findAssetImage(String assetName) {
  return find.byWidgetPredicate((widget) {
    return widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == assetName;
  });
}
