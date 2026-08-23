import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:silent_memory_app/core/constants/app_constants.dart';
import 'package:silent_memory_app/core/routing/app_router.dart';
import 'package:silent_memory_app/models/user_model.dart';
import 'package:silent_memory_app/providers/auth_provider.dart';
import 'package:silent_memory_app/services/auth_service.dart';

class MockAuthService implements AuthService {
  bool signOutCalled = false;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<UserModel?> getUserProfile(String uid) async => null;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Stream<UserModel?> streamUserProfile(String uid) => Stream.value(null);
}

class FakeUser implements User {
  @override
  final String uid;
  FakeUser(this.uid);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Router Provider & Navigation Tests', () {
    test('Fix 1: GoRouter instance is NOT recreated across auth/profile state changes', () {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
          currentUserProfileProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );
      addTearDown(container.dispose);

      final router1 = container.read(routerProvider);
      final router2 = container.read(routerProvider);

      expect(identical(router1, router2), isTrue);
    });

    testWidgets('Fix 2: Member allowed into /member/dashboard', (tester) async {
      final mockAuth = MockAuthService();
      final fakeUser = FakeUser('member-1');

      final memberUser = UserModel(
        userId: 'member-1',
        email: 'member@silentmemory.id',
        displayName: 'Member User',
        role: AppConstants.roleMember,
        status: AppConstants.userStatusActive,
        joinedAt: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        createdBy: 'admin',
        updatedBy: 'admin',
      );

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuth),
          authStateProvider.overrideWith((ref) => Stream.value(fakeUser)),
          currentUserProfileProvider.overrideWith((ref) => Stream.value(memberUser)),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, equals('/member/dashboard'));
    });

    testWidgets('Fix 2: Admin blocked from /member/dashboard and redirected to /admin/dashboard', (tester) async {
      final mockAuth = MockAuthService();
      final fakeUser = FakeUser('admin-1');

      final adminUser = UserModel(
        userId: 'admin-1',
        email: 'admin@silentmemory.id',
        displayName: 'Admin User',
        role: AppConstants.roleAdmin,
        status: AppConstants.userStatusActive,
        joinedAt: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        createdBy: 'superadmin',
        updatedBy: 'superadmin',
      );

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuth),
          authStateProvider.overrideWith((ref) => Stream.value(fakeUser)),
          currentUserProfileProvider.overrideWith((ref) => Stream.value(adminUser)),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Attempt to navigate manually to /member/dashboard
      router.go('/member/dashboard');
      await tester.pumpAndSettle();

      // Admin should be redirected back to /admin/dashboard
      expect(router.state.matchedLocation, equals('/admin/dashboard'));
    });

    testWidgets('Fix 2: Super Admin blocked from /member/dashboard and redirected to /super-admin/dashboard', (tester) async {
      final mockAuth = MockAuthService();
      final fakeUser = FakeUser('superadmin-1');

      final superAdminUser = UserModel(
        userId: 'superadmin-1',
        email: 'superadmin@silentmemory.id',
        displayName: 'Super Admin User',
        role: AppConstants.roleSuperAdmin,
        status: AppConstants.userStatusActive,
        joinedAt: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        createdBy: 'system',
        updatedBy: 'system',
      );

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuth),
          authStateProvider.overrideWith((ref) => Stream.value(fakeUser)),
          currentUserProfileProvider.overrideWith((ref) => Stream.value(superAdminUser)),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Attempt to navigate manually to /member/dashboard
      router.go('/member/dashboard');
      await tester.pumpAndSettle();

      // Super Admin should be redirected back to /super-admin/dashboard
      expect(router.state.matchedLocation, equals('/super-admin/dashboard'));
    });

    testWidgets('Fix 1 & Guard: Inactive user triggers signOut and is blocked at /login', (tester) async {
      final mockAuth = MockAuthService();
      final fakeUser = FakeUser('inactive-1');

      final inactiveUser = UserModel(
        userId: 'inactive-1',
        email: 'inactive@silentmemory.id',
        displayName: 'Inactive User',
        role: AppConstants.roleMember,
        status: AppConstants.userStatusInactive,
        joinedAt: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        createdBy: 'admin',
        updatedBy: 'admin',
      );

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuth),
          authStateProvider.overrideWith((ref) => Stream.value(fakeUser)),
          currentUserProfileProvider.overrideWith((ref) => Stream.value(inactiveUser)),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(routerProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(router.state.matchedLocation, equals('/login'));
      expect(mockAuth.signOutCalled, isTrue);
    });
  });
}
