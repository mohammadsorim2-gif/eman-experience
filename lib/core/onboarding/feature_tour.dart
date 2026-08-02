import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeatureTourStep {
  const FeatureTourStep({
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color accent;
}

Future<void> showFeatureTourIfNeeded({
  required BuildContext context,
  required List<FeatureTourStep> steps,
  required String nextLabel,
  required String finishLabel,
  required String skipLabel,
  String storageKey = 'eman_feature_tour_v1',
}) async {
  final preferences = await SharedPreferences.getInstance();
  if (preferences.getBool(storageKey) ?? false) return;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _FeatureTourDialog(
      steps: steps,
      nextLabel: nextLabel,
      finishLabel: finishLabel,
      skipLabel: skipLabel,
      onDone: () async {
        await preferences.setBool(storageKey, true);
        if (context.mounted) Navigator.of(context).pop();
      },
    ),
  );
}

class _FeatureTourDialog extends StatefulWidget {
  const _FeatureTourDialog({
    required this.steps,
    required this.nextLabel,
    required this.finishLabel,
    required this.skipLabel,
    required this.onDone,
  });

  final List<FeatureTourStep> steps;
  final String nextLabel;
  final String finishLabel;
  final String skipLabel;
  final Future<void> Function() onDone;

  @override
  State<_FeatureTourDialog> createState() => _FeatureTourDialogState();
}

class _FeatureTourDialogState extends State<_FeatureTourDialog> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[index];
    final last = index == widget.steps.length - 1;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: widget.onDone,
                  child: Text(widget.skipLabel),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: Column(
                  key: ValueKey(index),
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: step.accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Icon(step.icon, color: step.accent, size: 38),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      step.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      step.body,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.steps.length,
                  (dotIndex) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: dotIndex == index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: dotIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
        ),
      ),
    );
  }
}
