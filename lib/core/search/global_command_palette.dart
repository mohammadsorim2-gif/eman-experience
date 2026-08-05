import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalCommandItem {
  const GlobalCommandItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    required this.onSelected,
    this.keywords = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color color;
  final VoidCallback onSelected;
  final List<String> keywords;
}

Future<void> showGlobalCommandPalette({
  required BuildContext context,
  required String languageCode,
  required List<GlobalCommandItem> items,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .45),
    builder: (_) => _GlobalCommandPaletteDialog(
      languageCode: languageCode,
      items: items,
    ),
  );
}

class _GlobalCommandPaletteDialog extends StatefulWidget {
  const _GlobalCommandPaletteDialog({
    required this.languageCode,
    required this.items,
  });

  final String languageCode;
  final List<GlobalCommandItem> items;

  @override
  State<_GlobalCommandPaletteDialog> createState() =>
      _GlobalCommandPaletteDialogState();
}

class _GlobalCommandPaletteDialogState
    extends State<_GlobalCommandPaletteDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  int _selectedIndex = 0;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  List<GlobalCommandItem> get _results {
    final query = _normalize(_controller.text);
    if (query.isEmpty) return widget.items;
    final words = query.split(' ');
    final scored = <(GlobalCommandItem, int)>[];

    for (final item in widget.items) {
      final title = _normalize(item.title);
      final subtitle = _normalize(item.subtitle);
      final category = _normalize(item.category);
      final keywords = _normalize(item.keywords.join(' '));
      final haystack = '$title $subtitle $category $keywords';
      if (!words.every(haystack.contains)) continue;

      var score = 0;
      if (title == query) score += 100;
      if (title.startsWith(query)) score += 60;
      if (title.contains(query)) score += 35;
      if (keywords.contains(query)) score += 20;
      if (subtitle.contains(query)) score += 10;
      scored.add((item, score));
    }

    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final result in scored) result.$1];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _open(GlobalCommandItem item) {
    Navigator.of(context).pop();
    item.onSelected();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    if (_selectedIndex >= results.length) _selectedIndex = 0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 640),
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.arrowDown):
                _MoveSelectionIntent(1),
            SingleActivator(LogicalKeyboardKey.arrowUp):
                _MoveSelectionIntent(-1),
            SingleActivator(LogicalKeyboardKey.enter): _ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
          },
          child: Actions(
            actions: {
              _MoveSelectionIntent: CallbackAction<_MoveSelectionIntent>(
                onInvoke: (intent) {
                  if (results.isEmpty) return null;
                  setState(() {
                    _selectedIndex =
                        (_selectedIndex + intent.offset) % results.length;
                    if (_selectedIndex < 0) _selectedIndex = results.length - 1;
                  });
                  return null;
                },
              ),
              _ActivateIntent: CallbackAction<_ActivateIntent>(
                onInvoke: (_) {
                  if (results.isNotEmpty) _open(results[_selectedIndex]);
                  return null;
                },
              ),
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (_) => setState(() => _selectedIndex = 0),
                    decoration: InputDecoration(
                      hintText: _tx(
                        tr: 'Müşteri, ürün, sipariş, çalışan veya bölüm ara...',
                        ar: 'ابحث عن عميل أو منتج أو طلب أو موظف أو قسم...',
                        en: 'Search customers, products, orders, people or sections...',
                      ),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        tooltip: _tx(tr: 'Kapat', ar: 'إغلاق', en: 'Close'),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.search_off_rounded, size: 42),
                              const SizedBox(height: 12),
                              Text(
                                _tx(
                                  tr: 'Sonuç bulunamadı',
                                  ar: 'لا توجد نتائج',
                                  en: 'No results found',
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            final selected = index == _selectedIndex;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              child: Material(
                                color: selected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: ListTile(
                                  onTap: () => _open(item),
                                  onFocusChange: (focused) {
                                    if (focused) {
                                      setState(() => _selectedIndex = index);
                                    }
                                  },
                                  leading: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: item.color.withValues(alpha: .13),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(item.icon, color: item.color),
                                  ),
                                  title: Text(item.title),
                                  subtitle: Text(item.subtitle),
                                  trailing: Chip(label: Text(item.category)),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      const _KeyHint(label: '↑↓'),
                      const SizedBox(width: 8),
                      Text(_tx(tr: 'Gezin', ar: 'تنقل', en: 'Navigate')),
                      const SizedBox(width: 18),
                      const _KeyHint(label: 'Enter'),
                      const SizedBox(width: 8),
                      Text(_tx(tr: 'Aç', ar: 'فتح', en: 'Open')),
                      const Spacer(),
                      Text(
                        '${results.length} ${_tx(tr: 'sonuç', ar: 'نتيجة', en: 'results')}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _MoveSelectionIntent extends Intent {
  const _MoveSelectionIntent(this.offset);
  final int offset;
}

class _ActivateIntent extends Intent {
  const _ActivateIntent();
}
