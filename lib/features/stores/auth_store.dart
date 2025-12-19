import 'package:practice2/features/entities/user.dart';

abstract class AuthStore {
  /// Stream of current authentication state
  /// null means user is not authenticated
  Stream<User?> watchAuthState();

  /// Current authenticated user, null if not authenticated
  User? get currentUser;

  /// Sign in with email and password
  /// Throws [AuthException] if credentials are invalid
  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Sign up new user
  /// Throws [AuthException] if email already exists
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  /// Sign out current user
  Future<void> signOut();
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
