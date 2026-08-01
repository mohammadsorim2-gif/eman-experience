import '../models/app_user.dart';
import '../models/user_role.dart';

class AuthService {
  static AppUser currentUser = const AppUser(
    id: "guest",
    name: "Guest",
    email: "",
    role: UserRole.guest,
  );
}
