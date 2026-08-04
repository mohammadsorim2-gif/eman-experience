from pathlib import Path

SEARCH_FILE = Path("lib/core/search/global_search.dart")


def main() -> None:
    source = SEARCH_FILE.read_text(encoding="utf-8")

    source = source.replace(
        "    this.keywords = const [],\n",
        "    this.category = 'General',\n    this.keywords = const [],\n",
        1,
    )
    source = source.replace(
        "  final List<String> keywords;\n",
        "  final String category;\n  final List<String> keywords;\n",
        1,
    )

    old_results = """  List<AppSearchItem> get _results {
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
"""

    new_results = """  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه')
        .trim();
  }

  int _score(AppSearchItem item, String normalizedQuery) {
    if (normalizedQuery.isEmpty) return 1;
    final title = _normalize(item.title);
    final subtitle = _normalize(item.subtitle);
    final category = _normalize(item.category);
    final keywords = item.keywords.map(_normalize).toList();
    final tokens = normalizedQuery.split(RegExp(r'\\s+'));

    var score = 0;
    if (title == normalizedQuery) score += 100;
    if (title.startsWith(normalizedQuery)) score += 70;
    if (title.contains(normalizedQuery)) score += 50;
    if (category.contains(normalizedQuery)) score += 24;
    if (subtitle.contains(normalizedQuery)) score += 18;
    if (keywords.any((keyword) => keyword.contains(normalizedQuery))) score += 30;

    for (final token in tokens) {
      if (title.contains(token)) score += 16;
      if (subtitle.contains(token)) score += 6;
      if (category.contains(token)) score += 8;
      if (keywords.any((keyword) => keyword.contains(token))) score += 10;
    }
    return score;
  }

  List<AppSearchItem> get _results {
    final normalizedQuery = _normalize(query);
    final ranked = items
        .map((item) => (item: item, score: _score(item, normalizedQuery)))
        .where((entry) => normalizedQuery.isEmpty || entry.score > 0)
        .toList()
      ..sort((a, b) {
        final scoreComparison = b.score.compareTo(a.score);
        if (scoreComparison != 0) return scoreComparison;
        return a.item.title.compareTo(b.item.title);
      });
    return ranked.map((entry) => entry.item).toList();
  }
"""

    if old_results not in source:
        raise SystemExit("Search result block not found")
    source = source.replace(old_results, new_results, 1)

    source = source.replace(
        "        final item = results[index];\n        return Material(",
        "        final item = results[index];\n        final showCategoryHeader = index == 0 ||\n            results[index - 1].category != item.category;\n        return Column(\n          crossAxisAlignment: CrossAxisAlignment.start,\n          children: [\n            if (showCategoryHeader)\n              Padding(\n                padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),\n                child: Text(\n                  item.category,\n                  style: Theme.of(context).textTheme.labelLarge?.copyWith(\n                        color: Theme.of(context).colorScheme.primary,\n                      ),\n                ),\n              ),\n            Material(",
        1,
    )
    source = source.replace(
        "        );\n      },\n    );\n  }\n}",
        "            ),\n          ],\n        );\n      },\n    );\n  }\n}",
        1,
    )

    SEARCH_FILE.write_text(source, encoding="utf-8")
    print("Global search upgraded with categories and relevance ranking")


if __name__ == "__main__":
    main()
