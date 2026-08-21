import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Provider for AuthService instance
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider streaming current Firebase Auth user
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider streaming current user profile from Firestore
final currentUserProfileProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.asData?.value;

  if (user == null) {
    return Stream.value(null);
  }

  final authService = ref.watch(authServiceProvider);
  return authService.streamUserProfile(user.uid);
});

/// Helper provider returning current role string (null if unauthenticated, loading, or error)
final userRoleProvider = Provider<String?>((ref) {
  final profileAsync = ref.watch(currentUserProfileProvider);
  return profileAsync.when(
    data: (user) => user?.role,
    loading: () => null,
    error: (err, stack) => null,
  );
});

/// Helper provider returning whether current user is inactive
final isUserInactiveProvider = Provider<bool>((ref) {
  final profileAsync = ref.watch(currentUserProfileProvider);
  return profileAsync.when(
    data: (user) => user?.status == AppConstants.userStatusInactive,
    loading: () => false,
    error: (err, stack) => false,
  );
});



