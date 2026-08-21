import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silent_memory_app/core/constants/app_constants.dart';
import 'package:silent_memory_app/models/user_model.dart';
import 'package:silent_memory_app/providers/auth_provider.dart';

void main() {
  group('Inactive User Handling Tests', () {
    test('UserModel correctly reflects active and inactive status', () {
      final activeUser = UserModel(
        userId: 'user-1',
        email: 'active@silentmemory.id',
        displayName: 'Active User',
        role: AppConstants.roleMember,
        status: AppConstants.userStatusActive,
        joinedAt: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        createdBy: 'admin',
        updatedBy: 'admin',
      );

      final inactiveUser = UserModel(
        userId: 'user-2',
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

      expect(activeUser.isActive, isTrue);
      expect(activeUser.status, equals(AppConstants.userStatusActive));

      expect(inactiveUser.isActive, isFalse);
      expect(inactiveUser.status, equals(AppConstants.userStatusInactive));
    });

    test('isUserInactiveProvider evaluates user status correctly', () async {
      final container = ProviderContainer(
        overrides: [
          currentUserProfileProvider.overrideWith(
            (ref) => Stream.value(
              UserModel(
                userId: 'user-inactive',
                email: 'inactive@silentmemory.id',
                displayName: 'Inactive User',
                role: AppConstants.roleMember,
                status: AppConstants.userStatusInactive,
                joinedAt: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
                updatedAt: DateTime(2026, 1, 1),
                createdBy: 'admin',
                updatedBy: 'admin',
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(currentUserProfileProvider.future);
      final isInactive = container.read(isUserInactiveProvider);
      expect(isInactive, isTrue);
    });

    test('isUserInactiveProvider returns false for active user', () async {
      final container = ProviderContainer(
        overrides: [
          currentUserProfileProvider.overrideWith(
            (ref) => Stream.value(
              UserModel(
                userId: 'user-active',
                email: 'active@silentmemory.id',
                displayName: 'Active User',
                role: AppConstants.roleMember,
                status: AppConstants.userStatusActive,
                joinedAt: DateTime(2026, 1, 1),
                createdAt: DateTime(2026, 1, 1),
                updatedAt: DateTime(2026, 1, 1),
                createdBy: 'admin',
                updatedBy: 'admin',
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(currentUserProfileProvider.future);
      final isInactive = container.read(isUserInactiveProvider);
      expect(isInactive, isFalse);
    });
  });
}
