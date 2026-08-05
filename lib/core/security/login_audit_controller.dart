import 'package:flutter/foundation.dart';

class LoginAuditEntry {
  const LoginAuditEntry({
    required this.userId,
    required this.email,
    required this.success,
    required this.timestamp,
    this.ipAddress,
    this.device,
    this.failureReason,
  });

  final String userId;
  final String email;
  final bool success;
  final DateTime timestamp;
  final String? ipAddress;
  final String? device;
  final String? failureReason;
}

class LoginAuditController extends ChangeNotifier {
  LoginAuditController._();

  static final LoginAuditController instance = LoginAuditController._();

  final List<LoginAuditEntry> _entries = [];

  List<LoginAuditEntry> get entries => List.unmodifiable(_entries);

  List<LoginAuditEntry> get failedEntries =>
      _entries.where((entry) => !entry.success).toList(growable: false);

  void record(LoginAuditEntry entry) {
    _entries.insert(0, entry);
    if (_entries.length > 500) _entries.removeRange(500, _entries.length);
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }
}
