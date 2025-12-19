import 'dart:async';

import 'package:practice2/features/entities/user.dart';
import 'package:practice2/features/stores/auth_store.dart';

class AuthStoreImpl implements AuthStore {
  // Mock storage: email -> (user, password)
  final Map<String, ({User user, String password})> _mockUsers = {};
  User? _currentUser;
  final _controller = StreamController<User?>.broadcast();

  @override
  Stream<User?> watchAuthState() async* {
    yield _currentUser;

    await for (final user in _controller.stream) {
      yield user;
    }
  }

  @override
  User? get currentUser => _currentUser;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw AuthException('Password cannot be empty');
    }

    final stored = _mockUsers[email];
    if (stored == null) {
      throw AuthException('User not found');
    }

    if (stored.password != password) {
      throw AuthException('Invalid password');
    }

    _currentUser = stored.user;
    _controller.add(_currentUser);
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (email.trim().isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw AuthException('Password cannot be empty');
    }
    if (firstName.trim().isEmpty) {
      throw AuthException('First name cannot be empty');
    }
    if (lastName.trim().isEmpty) {
      throw AuthException('Last name cannot be empty');
    }

    if (_mockUsers.containsKey(email)) {
      throw AuthException('Email already registered');
    }

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      firstName: firstName,
      lastName: lastName,
    );

    _mockUsers[email] = (user: user, password: password);
    _currentUser = user;
    _controller.add(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}
