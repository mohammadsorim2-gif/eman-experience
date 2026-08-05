import 'app_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    this.department,
    this.isActive = true,
    this.permissionsOverride,
  });

  final String id;
  final String email;
  final String displayName;
  final AppRole role;
  final String? department;
  final bool isActive;
  final Set<AppPermission>? permissionsOverride;

  Set<AppPermission> get permissions =>
      permissionsOverride ?? RolePermissions.matrix[role] ?? const {};

  bool can(AppPermission permission) =>
      isActive && permissions.contains(permission);

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    AppRole? role,
    String? department,
    bool? isActive,
    Set<AppPermission>? permissionsOverride,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      department: department ?? this.department,
      isActive: isActive ?? this.isActive,
      permissionsOverride: permissionsOverride ?? this.permissionsOverride,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'role': role.name,
    'department': department,
    'isActive': isActive,
    'permissionsOverride': permissionsOverride
        ?.map((permission) => permission.name)
        .toList(),
  };

  factory AppUser.fromMap(Map<String, Object?> map) {
    final roleName = map['role'] as String? ?? AppRole.worker.name;
    final role = AppRole.values.firstWhere(
      (item) => item.name == roleName,
      orElse: () => AppRole.worker,
    );
    final rawPermissions = map['permissionsOverride'];
    final override = rawPermissions is List
        ? rawPermissions
              .whereType<String>()
              .map(
                (name) => AppPermission.values.firstWhere(
                  (item) => item.name == name,
                  orElse: () => AppPermission.viewDashboard,
                ),
              )
              .toSet()
        : null;

    return AppUser(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? '',
      role: role,
      department: map['department'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      permissionsOverride: override,
    );
  }
}
