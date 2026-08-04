import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalSearchShortcut extends StatelessWidget {
  const GlobalSearchShortcut({
    required this.child,
    required this.onSearch,
    super.key,
  });

  final Widget child;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): onSearch,
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): onSearch,
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
