import 'package:flutter/material.dart';

class AppSearchItem {
  const AppSearchItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.destinationIndex,
    this.keywords = const [],
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final int destinationIndex;
  final List<String> keywords;
}

Future<void> showGlobalSearch({
  required BuildContext context,
  required List<AppSearchItem> items,
  required ValueChanged<int> onOpen,
  required String hint,
  required String emptyLabel,
}) async {
  final result = await showSearch<AppSearchItem?>(
    context: context,
    delegate: _GlobalSearchDelegate(
      items: items,
      hint: hint,
      emptyLabel: emptyLabel,
    ),
  );
  if (result != null) onOpen(result.destinationIndex);
}

class _GlobalSearchDelegate extends SearchDelegate<AppSearchItem?> {
  _GlobalSearchDelegate({
    required this.items,
    required this.hint,
    required this.emptyLabel,
  }) : super(searchFieldLabel: hint);

  final List<AppSearchItem> items;
  final String hint;
  final String emptyLabel;

  List<AppSearchItem> get _results {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return items;
    return items.where((item) {
      final corpus = <String>[
        item.title,
        item.subtitle,
        ...item.keywords,
      ].join(' ').toLowerCase();
      return corpus.contains(normalized);
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
          onPressed: () => query = '',
          icon: const Icon(Icons.close_rounded),
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = _results;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 52),
            const SizedBox(height: 14),
            Text(emptyLabel, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = results[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => close(context, item),
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: item.accent.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: item.accent, size: 23),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
