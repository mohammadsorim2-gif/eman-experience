import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SectionOnboardingStep {
  const SectionOnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    this.tip,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final String? tip;
}

class SectionOnboarding {
  const SectionOnboarding._();

  static Future<void> showFirstVisit({
    required BuildContext context,
    required String sectionKey,
    required String sectionTitle,
    required List<SectionOnboardingStep> steps,
    required String nextLabel,
    required String backLabel,
    required String finishLabel,
    required String skipLabel,
    bool force = false,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final storageKey = 'eman_section_onboarding_$sectionKey';
    if (!force && (preferences.getBool(storageKey) ?? false)) return;
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SectionOnboardingSheet(
        title: sectionTitle,
        steps: steps,
        nextLabel: nextLabel,
        backLabel: backLabel,
        finishLabel: finishLabel,
        skipLabel: skipLabel,
        onDone: () async {
          await preferences.setBool(storageKey, true);
          if (sheetContext.mounted) Navigator.of(sheetContext).pop();
        },
      ),
    );
  }

  static Future<void> reset(String sectionKey) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('eman_section_onboarding_$sectionKey');
  }
}

class _SectionOnboardingSheet extends StatefulWidget {
  const _SectionOnboardingSheet({
    required this.title,
    required this.steps,
    required this.nextLabel,
    required this.backLabel,
    required this.finishLabel,
    required this.skipLabel,
    required this.onDone,
  });

  final String title;
  final List<SectionOnboardingStep> steps;
  final String nextLabel;
  final String backLabel;
  final String finishLabel;
  final String skipLabel;
  final Future<void> Function() onDone;

  @override
  State<_SectionOnboardingSheet> createState() =>
      _SectionOnboardingSheetState();
}

class _SectionOnboardingSheetState extends State<_SectionOnboardingSheet> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[index];
    final last = index == widget.steps.length - 1;
    final compact = MediaQuery.sizeOf(context).width < 620;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 760),
        margin: EdgeInsets.all(compact ? 10 : 20),
        padding: EdgeInsets.all(compact ? 20 : 28),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 40,
              offset: Offset(0, 18),
              color: Color(0x26052A45),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: widget.onDone,
                  child: Text(widget.skipLabel),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Container(
                key: ValueKey(index),
                padding: EdgeInsets.all(compact ? 18 : 24),
                decoration: BoxDecoration(
                  color: step.accent.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: step.accent.withValues(alpha: .16)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: compact ? 54 : 64,
                      height: compact ? 54 : 64,
                      decoration: BoxDecoration(
                        color: step.accent.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        step.icon,
                        color: step.accent,
                        size: compact ? 28 : 32,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            step.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (step.tip != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: step.accent.withValues(alpha: .14),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline_rounded,
                                    size: 18,
                                    color: step.accent,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(step.tip!)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(
                      widget.steps.length,
                      (dot) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: dot == index ? 26 : 8,
                        height: 8,
                        margin: const EdgeInsetsDirectional.only(end: 6),
                        decoration: BoxDecoration(
                          color: dot == index
                              ? step.accent
                              : Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                ),
                if (index > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => index -= 1),
                    child: Text(widget.backLabel),
                  ),
                if (index > 0) const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: last
                      ? widget.onDone
                      : () => setState(() => index += 1),
                  icon: Icon(
                    last ? Icons.check_rounded : Icons.arrow_forward_rounded,
                  ),
                  label: Text(last ? widget.finishLabel : widget.nextLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
