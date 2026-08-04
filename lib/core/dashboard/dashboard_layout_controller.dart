import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardWidgetConfig {
  const DashboardWidgetConfig({
    required this.id,
    required this.visible,
    required this.order,
  });

  final String id;
  final bool visible;
  final int order;

  DashboardWidgetConfig copyWith({bool? visible, int? order}) {
    return DashboardWidgetConfig(
      id: id,
      visible: visible ?? this.visible,
      order: order ?? this.order,
    );
  }
}

class DashboardLayoutController extends ChangeNotifier {
  DashboardLayoutController._();

  static const _storageKey = 'dashboard_layout_v1';
  static final DashboardLayoutController instance =
      DashboardLayoutController._();

  static const defaultWidgetIds = <String>[
    'sales',
    'production',
    'orders',
    'inventory',
    'machines',
    'employees',
    'shipments',
    'delays',
  ];

  List<DashboardWidgetConfig> _widgets = [
    for (var index = 0; index < defaultWidgetIds.length; index++)
      DashboardWidgetConfig(
        id: defaultWidgetIds[index],
        visible: true,
        order: index,
      ),
  ];

  bool _initialized = false;

  bool get initialized => _initialized;

  List<DashboardWidgetConfig> get widgets {
    final result = [..._widgets]..sort((a, b) => a.order.compareTo(b.order));
    return List.unmodifiable(result);
  }

  List<String> get visibleWidgetIds => widgets
      .where((item) => item.visible)
      .map((item) => item.id)
      .toList(growable: false);

  Future<void> initialize() async {
    if (_initialized) return;

    final preferences = await SharedPreferences.getInstance();
    final stored = preferences.getStringList(_storageKey);

    if (stored != null && stored.isNotEmpty) {
      final parsed = <DashboardWidgetConfig>[];
      for (var index = 0; index < stored.length; index++) {
        final parts = stored[index].split('|');
        if (parts.length != 2) continue;
        final id = parts[0];
        if (!defaultWidgetIds.contains(id)) continue;
        parsed.add(
          DashboardWidgetConfig(
            id: id,
            visible: parts[1] == '1',
            order: index,
          ),
        );
      }

      for (final id in defaultWidgetIds) {
        if (parsed.any((item) => item.id == id)) continue;
        parsed.add(
          DashboardWidgetConfig(
            id: id,
            visible: true,
            order: parsed.length,
          ),
        );
      }

      if (parsed.isNotEmpty) _widgets = parsed;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> setVisibility(String id, bool visible) async {
    final index = _widgets.indexWhere((item) => item.id == id);
    if (index == -1 || _widgets[index].visible == visible) return;

    _widgets[index] = _widgets[index].copyWith(visible: visible);
    notifyListeners();
    await _persist();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final ordered = widgets.toList();
    if (oldIndex < 0 || oldIndex >= ordered.length) return;
    if (newIndex < 0 || newIndex > ordered.length) return;

    if (newIndex > oldIndex) newIndex -= 1;
    final moved = ordered.removeAt(oldIndex);
    ordered.insert(newIndex, moved);

    _widgets = [
      for (var index = 0; index < ordered.length; index++)
        ordered[index].copyWith(order: index),
    ];

    notifyListeners();
    await _persist();
  }

  Future<void> reset() async {
    _widgets = [
      for (var index = 0; index < defaultWidgetIds.length; index++)
        DashboardWidgetConfig(
          id: defaultWidgetIds[index],
          visible: true,
          order: index,
        ),
    ];

    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }

  Future<void> _persist() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      [for (final item in widgets) '${item.id}|${item.visible ? 1 : 0}'],
    );
  }
}
