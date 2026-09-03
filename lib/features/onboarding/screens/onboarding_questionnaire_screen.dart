import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/onboarding_questionnaire_answers.dart';

class OnboardingQuestionnaireScreen extends StatefulWidget {
  const OnboardingQuestionnaireScreen({
    super.key,
    this.initialAnswers,
    this.onCompleted,
  });

  final OnboardingQuestionnaireAnswers? initialAnswers;
  final Future<void> Function(OnboardingQuestionnaireAnswers answers)?
  onCompleted;

  @override
  State<OnboardingQuestionnaireScreen> createState() =>
      _OnboardingQuestionnaireScreenState();
}

class _OnboardingQuestionnaireScreenState
    extends State<OnboardingQuestionnaireScreen> {
  static const List<_Question> questions = [
    _Question(
      section: 'Your baseline',
      prompt:
          'At the end of a typical day, how much energy do you usually have left?',
      minimum: 1,
      maximum: 5,
      lowLabel: 'Almost drained',
      highLabel: 'Fully energised',
      initialValue: 3,
      scaleType: _QuestionScaleType.energyLevel,
    ),
    _Question(
      section: 'Schedule structure',
      prompt:
          'When your day includes many hours of scheduled activities, how does that usually affect your energy?',
    ),
    _Question(
      section: 'Schedule structure',
      prompt:
          'How do back-to-back scheduled activities usually affect your energy?',
    ),
    _Question(
      section: 'Schedule structure',
      prompt:
          'How do long continuous blocks of scheduled activities without a break usually affect your energy?',
    ),
    _Question(
      section: 'Schedule structure',
      prompt: 'How do long gaps between activities usually affect your energy?',
    ),
    _Question(
      section: 'Activity types',
      prompt:
          'How do focused activities, such as studying, usually affect your energy?',
    ),
    _Question(
      section: 'Activity types',
      prompt: 'How do social activities usually affect your energy?',
    ),
    _Question(
      section: 'Activity types',
      prompt:
          'How do life admin tasks, such as errands, chores, shopping, or appointments, usually affect your energy?',
    ),
    _Question(
      section: 'Activity types',
      prompt: 'How does exercise usually affect your energy?',
    ),
    _Question(
      section: 'Understanding your energy',
      prompt: 'I understand how my schedule affects my energy level.',
      lowLabel: 'Strongly disagree',
      highLabel: 'Strongly agree',
      scaleType: _QuestionScaleType.agreement,
    ),
    _Question(
      section: 'Understanding your energy',
      prompt:
          'Looking at my schedule, I can estimate how much energy I will have left at the end of the day.',
      lowLabel: 'Strongly disagree',
      highLabel: 'Strongly agree',
      scaleType: _QuestionScaleType.agreement,
    ),
  ];

  late final List<double> answers;
  int currentQuestionIndex = 0;
  bool isComplete = false;
  bool isSaving = false;
  String? saveErrorMessage;

  @override
  void initState() {
    super.initState();

    final initialAnswers = widget.initialAnswers;
    answers = initialAnswers == null
        ? questions.map((question) => question.initialValue).toList()
        : [
            initialAnswers.typicalEnergyScore.toDouble(),
            initialAnswers.busyImpactScore.toDouble(),
            initialAnswers.backToBackImpactScore.toDouble(),
            initialAnswers.longBlockImpactScore.toDouble(),
            initialAnswers.freeGapImpactScore.toDouble(),
            initialAnswers.focusImpactScore.toDouble(),
            initialAnswers.socialImpactScore.toDouble(),
            initialAnswers.lifeAdminImpactScore.toDouble(),
            initialAnswers.exerciseImpactScore.toDouble(),
            initialAnswers.calendarUnderstandingScore.toDouble(),
            initialAnswers.schedulePredictionConfidenceScore.toDouble(),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Energy setup')),
      body: SafeArea(
        top: false,
        child: isComplete
            ? _CompletionView(
                onReview: () {
                  setState(() {
                    currentQuestionIndex = 0;
                    isComplete = false;
                    saveErrorMessage = null;
                  });
                },
                onDone: isSaving ? null : completeQuestionnaire,
                isSaving: isSaving,
                errorMessage: saveErrorMessage,
              )
            : _buildQuestionnaire(context),
      ),
    );
  }

  Widget _buildQuestionnaire(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} of ${questions.length}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceSoft,
                  color: AppColors.forestGreen,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.section,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.forestGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question.prompt,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 38),
                      Center(
                        child: Semantics(
                          label:
                              'Selected value ${answers[currentQuestionIndex].round()}',
                          child: ExcludeSemantics(
                            child: Image.asset(
                              question.emojiAssetPathFor(
                                answers[currentQuestionIndex].round(),
                              ),
                              width: 64,
                              height: 64,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackShape: const _InsetSliderTrackShape(
                            horizontalInset: 14,
                          ),
                          showValueIndicator: ShowValueIndicator.never,
                        ),
                        child: Slider(
                          value: answers[currentQuestionIndex],
                          min: question.minimum.toDouble(),
                          max: question.maximum.toDouble(),
                          divisions: question.maximum - question.minimum,
                          label: answers[currentQuestionIndex]
                              .round()
                              .toString(),
                          padding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              answers[currentQuestionIndex] = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ScaleNumbers(
                        minimum: question.minimum,
                        maximum: question.maximum,
                        selectedValue: answers[currentQuestionIndex].round(),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              question.lowLabel,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              question.highLabel,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Row(
            children: [
              if (currentQuestionIndex > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: previousQuestion,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: nextQuestion,
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
                  child: Text(
                    currentQuestionIndex == questions.length - 1
                        ? 'Finish'
                        : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void previousQuestion() {
    setState(() {
      currentQuestionIndex--;
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex == questions.length - 1) {
      setState(() {
        isComplete = true;
      });
      return;
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  Future<void> completeQuestionnaire() async {
    final result = OnboardingQuestionnaireAnswers(
      typicalEnergyScore: answers[0].round(),
      busyImpactScore: answers[1].round(),
      backToBackImpactScore: answers[2].round(),
      longBlockImpactScore: answers[3].round(),
      freeGapImpactScore: answers[4].round(),
      focusImpactScore: answers[5].round(),
      socialImpactScore: answers[6].round(),
      lifeAdminImpactScore: answers[7].round(),
      exerciseImpactScore: answers[8].round(),
      calendarUnderstandingScore: answers[9].round(),
      schedulePredictionConfidenceScore: answers[10].round(),
    );

    if (widget.onCompleted == null) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      isSaving = true;
      saveErrorMessage = null;
    });

    try {
      await widget.onCompleted!(result);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isSaving = false;
        saveErrorMessage = 'Could not save your answers. Please try again.';
      });
    }
  }
}

class _InsetSliderTrackShape extends RoundedRectSliderTrackShape {
  const _InsetSliderTrackShape({required this.horizontalInset});

  final double horizontalInset;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 0;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;

    return Rect.fromLTWH(
      offset.dx + horizontalInset,
      trackTop,
      parentBox.size.width - horizontalInset * 2,
      trackHeight,
    );
  }
}

class _ScaleNumbers extends StatelessWidget {
  const _ScaleNumbers({
    required this.minimum,
    required this.maximum,
    required this.selectedValue,
  });

  final int minimum;
  final int maximum;
  final int selectedValue;

  @override
  Widget build(BuildContext context) {
    const circleSize = 28.0;
    final valueCount = maximum - minimum + 1;

    return SizedBox(
      height: circleSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - circleSize;

          return Stack(
            children: [
              for (var index = 0; index < valueCount; index++)
                Positioned(
                  left: availableWidth * index / (valueCount - 1),
                  child: AnimatedContainer(
                    key: ValueKey('scale-value-${minimum + index}'),
                    duration: const Duration(milliseconds: 160),
                    width: circleSize,
                    height: circleSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: minimum + index == selectedValue
                          ? AppColors.forestGreen
                          : AppColors.surfaceSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      (minimum + index).toString(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: minimum + index == selectedValue
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
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

class _CompletionView extends StatelessWidget {
  const _CompletionView({
    required this.onReview,
    required this.onDone,
    required this.isSaving,
    required this.errorMessage,
  });

  final VoidCallback onReview;
  final VoidCallback? onDone;
  final bool isSaving;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.mintTag,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.spa_outlined,
              size: 44,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Setup preview complete',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Your answers will give Cal a starting point for your early energy forecasts.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: isSaving ? null : onReview,
            child: const Text('Review answers'),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onDone,
            child: isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _Question {
  const _Question({
    required this.section,
    required this.prompt,
    this.minimum = 1,
    this.maximum = 5,
    this.lowLabel = 'Drains my energy',
    this.highLabel = 'Improves my energy',
    this.initialValue = 3,
    this.scaleType = _QuestionScaleType.energyImpact,
  });

  final String section;
  final String prompt;
  final int minimum;
  final int maximum;
  final String lowLabel;
  final String highLabel;
  final double initialValue;
  final _QuestionScaleType scaleType;

  String emojiAssetPathFor(int value) {
    final index = value - minimum;

    return switch (scaleType) {
      _QuestionScaleType.energyLevel => const [
        'assets/images/emoji_1.png',
        'assets/images/emoji_2.png',
        'assets/images/emoji_3.png',
        'assets/images/emoji_4.png',
        'assets/images/emoji_5.png',
      ][index],
      _QuestionScaleType.energyImpact => const [
        'assets/images/emoji_1.png',
        'assets/images/emoji_2.png',
        'assets/images/emoji_3.png',
        'assets/images/emoji_4.png',
        'assets/images/emoji_5.png',
      ][index],
      _QuestionScaleType.agreement => const [
        'assets/images/emoji_1.png',
        'assets/images/emoji_2.png',
        'assets/images/emoji_3.png',
        'assets/images/emoji_4.png',
        'assets/images/emoji_5.png',
      ][index],
    };
  }
}

enum _QuestionScaleType { energyLevel, energyImpact, agreement }
