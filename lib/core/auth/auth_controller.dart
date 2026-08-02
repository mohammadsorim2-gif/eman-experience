import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_role.dart';
import 'app_user.dart';

class AuthController extends ChangeNotifier {
  static const _sessionEmailKey = 'eman_session_email';
  static const _sessionRoleKey = 'eman_session_role';
  static const _sessionNameKey = 'eman_session_name';

  AppUser? _currentUser;
  bool _loading = true;

  AppUser? get currentUser => _currentUser;
  bool get loading => _loading;
  bool get signedIn => _currentUser != null;

  Future<void> restoreSession() async {
    final preferences = await SharedPreferences.getInstance();
    final email = preferences.getString(_sessionEmailKey);
    final roleName = preferences.getString(_sessionRoleKey);
    final name = preferences.getString(_sessionNameKey);

    if (email != null && roleName != null) {
      final role = AppRole.values.firstWhere(
        (item) => item.name == roleName,
        orElse: () => AppRole.worker,
      );
      _currentUser = AppUser(
        id: email,
        email: email,
        displayName: name ?? email.split('@').first,
        role: role,
      );
    }

    _loading = false;
    notifyListeners();
  }

  Future<String?> signIn({
    required String email,
    required String password,
    AppRole? role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.contains('@')) return 'invalid_email';
    if (password.length < 6) return 'invalid_password';

    final resolvedRole = role ?? _inferRole(normalizedEmail);
    final user = AppUser(
      id: normalizedEmail,
      email: normalizedEmail,
      displayName: _nameFromEmail(normalizedEmail),
      role: resolvedRole,
    );

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_sessionEmailKey, user.email);
    await preferences.setString(_sessionRoleKey, user.role.name);
    await preferences.setString(_sessionNameKey, user.displayName);

    _currentUser = user;
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_sessionEmailKey);
    await preferences.remove(_sessionRoleKey);
    await preferences.remove(_sessionNameKey);
    _currentUser = null;
    notifyListeners();
  }

  bool can(AppPermission permission) =>
      _currentUser?.can(permission) ?? false;

  AppRole _inferRole(String email) {
    if (email.startsWith('owner') || email.startsWith('admin')) {
      return AppRole.owner;
    }
    if (email.startsWith('manager')) return AppRole.generalManager;
    if (email.startsWith('sales')) return AppRole.sales;
    if (email.startsWith('factory') || email.startsWith('production')) {
      return AppRole.productionManager;
    }
    if (email.startsWith('account')) return AppRole.accounting;
    if (email.startsWith('warehouse')) return AppRole.warehouse;
    return AppRole.worker;
  }

  String _nameFromEmail(String email) {
    final value = email.split('@').first.replaceAll(RegExp(r'[._-]+'), ' ');
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
