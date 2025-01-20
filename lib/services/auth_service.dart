// lib/services/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  
  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Auth state
  bool _isAuthenticated = false;
  AuthUser? _currentUser;
  final _authStateController = StreamController<AuthUser?>.broadcast();

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  AuthUser? get currentUser => _currentUser;
  Stream<AuthUser?> get authStateChanges => _authStateController.stream;

  // Initialize the auth service
  Future<void> initialize() async {
    try {
      // Here you would typically load stored user data
      // For now, we'll just simulate it
      await Future.delayed(const Duration(milliseconds: 500));
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
    }
  }

  // Sign in with email and password
  Future<AuthUser> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Validate credentials (replace with actual validation)
      if (email.isEmpty || password.isEmpty) {
        throw AuthException('Invalid credentials');
      }

      // Create user
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@')[0],
        photoUrl: null,
      );

      // Save user data
      await _saveUserData(user);

      return user;
    } catch (e) {
      throw AuthException('Failed to sign in: $e');
    }
  }

  // Sign up with email and password
  Future<AuthUser> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Validate input
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        throw AuthException('Invalid input');
      }

      // Create user
      final user = AuthUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        photoUrl: null,
      );

      // Save user data
      await _saveUserData(user);

      return user;
    } catch (e) {
      throw AuthException('Failed to sign up: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _currentUser = null;
      _isAuthenticated = false;
      _authStateController.add(null);
      notifyListeners();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  // Update user profile
  Future<AuthUser> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      if (_currentUser == null) {
        throw AuthException('No user logged in');
      }

      final updatedUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );

      await _saveUserData(updatedUser);
      return updatedUser;
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  // Save user data
  Future<void> _saveUserData(AuthUser user) async {
    try {
      _currentUser = user;
      _isAuthenticated = true;
      _authStateController.add(user);
      notifyListeners();
    } catch (e) {
      throw AuthException('Failed to save user data: $e');
    }
  }

  // Dispose resources
  @override
  void dispose() {
    _authStateController.close();
    super.dispose();
  }
}

// Auth User model
class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  AuthUser copyWith({
    String? name,
    String? photoUrl,
  }) {
    return AuthUser(
      id: id,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photoUrl'],
    );
  }

  @override
  String toString() => 'AuthUser(id: $id, email: $email, name: $name)';
}

// Auth Exception
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

// Example usage:
/*
void main() async {
  final auth = AuthService();
  await auth.initialize();

  // Listen to auth changes
  auth.addListener(() {
    print('Auth state changed: ${auth.isAuthenticated}');
  });

  try {
    // Sign up
    final user = await auth.signUpWithEmailAndPassword(
      'test@example.com',
      'password123',
      'Test User',
    );
    print('Signed up: ${user.name}');

    // Sign in
    final signedInUser = await auth.signInWithEmailAndPassword(
      'test@example.com',
      'password123',
    );
    print('Signed in: ${signedInUser.name}');

    // Update profile
    final updatedUser = await auth.updateProfile(
      name: 'Updated Name',
    );
    print('Updated profile: ${updatedUser.name}');

    // Sign out
    await auth.signOut();
    print('Signed out');
  } on AuthException catch (e) {
    print('Auth error: ${e.message}');
  }
}
*/