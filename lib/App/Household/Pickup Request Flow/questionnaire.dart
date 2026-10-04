import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Pickup Confirmation :
import 'package:public_health/App/Household/Pickup%20Request%20Flow/requestconfirmation.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  int _currentQuestion = 0;
  String? _selectedAnswer;
  List<int> qna = [0, 0, 0];

  void _next(List<String> questions) {
    if (_selectedAnswer == null) return;

    if (_currentQuestion < questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
      });
    } else {
      final pickuprequestdata = Provider.of<PickupRequestProvider>(
        context,
        listen: false,
      );

      pickuprequestdata.setQna(qna);

      if (!mounted) return;
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => const PickupConfirmationPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final questions = [
      l10n.sharpObjectsQuestion,
      l10n.expiredMedicineQuestion,
      l10n.bodyFluidsQuestion,
    ];

    return AppScaffold(
      showBack: false,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),

          // Heading
          Text(
            l10n.quickCheck,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            l10n.quickCheckSubtitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 28),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              border: Border.all(color: AppColors.textPrimary, width: 1.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_currentQuestion + 1} / ${questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Question
                Text(
                  questions[_currentQuestion],
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 24),

                // Yes
                _AnswerOption(
                  text: l10n.yes,
                  selected: _selectedAnswer == l10n.yes,
                  onTap: () {
                    setState(() {
                      qna[_currentQuestion] = 1;
                      _selectedAnswer = l10n.yes;
                    });
                  },
                ),

                const SizedBox(height: 14),

                // No
                _AnswerOption(
                  text: l10n.no,
                  selected: _selectedAnswer == l10n.no,
                  onTap: () {
                    setState(() {
                      qna[_currentQuestion] = 0;
                      _selectedAnswer = l10n.no;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom buttons
      bottom: Column(
        children: [
          AppPrimaryButton(
            text: _currentQuestion == questions.length - 1
                ? l10n.continueButton
                : l10n.next,
            onPressed: () => _next(questions),
          ),

          const SizedBox(height: 12),

          AppSecondaryButton(
            text: l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.yellow : AppColors.textPrimary,
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
