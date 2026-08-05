import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SectionTourStep {
  const SectionTourStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
}

class SectionTourController {
  const SectionTourController._();

  static const _storagePrefix = 'section_tour_seen_';

  static Future<void> showIfNeeded({
    required BuildContext context,
    required String sectionId,
    required List<SectionTourStep> steps,
    required String nextLabel,
    required String finishLabel,
    required String skipLabel,
    bool force = false,
  }) async {
    if (steps.isEmpty || !context.mounted) return;

    final preferences = await SharedPreferences.getInstance();
    final key = '$_storagePrefix$sectionId';
    final seen = preferences.getBool(key) ?? false;
    if (seen && !force) return;
    if (!context.mounted) return;

    final completed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _SectionTourDialog(
        steps: steps,
        nextLabel: nextLabel,
        finishLabel: finishLabel,
        skipLabel: skipLabel,
      ),
    );

    if (completed == true) {
      await preferences.setBool(key, true);
    }
  }

  static Future<void> reset(String sectionId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('$_storagePrefix$sectionId');
  }

  static Future<void> resetAll(Iterable<String> sectionIds) async {
    final preferences = await SharedPreferences.getInstance();
    for (final sectionId in sectionIds) {
      await preferences.remove('$_storagePrefix$sectionId');
    }
  }
}

class _SectionTourDialog extends StatefulWidget {
  const _SectionTourDialog({
    required this.steps,
    required this.nextLabel,
    required this.finishLabel,
    required this.skipLabel,
  });

  final List<SectionTourStep> steps;
  final String nextLabel;
  final String finishLabel;
  final String skipLabel;

  @override
  State<_SectionTourDialog> createState() => _SectionTourDialogState();
}

class _SectionTourDialogState extends State<_SectionTourDialog> {
  int _index = 0;

  bool get _isLast => _index == widget.steps.length - 1;

  void _next() {
    if (_isLast) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _index += 1);
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_index];

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: step.accent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(step.icon, color: step.accent, size: 30),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(widget.skipLabel),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Column(
                  key: ValueKey(_index),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(widget.steps.length, (index) {
                        final selected = index == _index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: selected ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsetsDirectional.only(end: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? step.accent
                                : step.accent.withValues(alpha: .22),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        );
                      }),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _next,
                    icon: Icon(
                      _isLast
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(
                      _isLast ? widget.finishLabel : widget.nextLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
