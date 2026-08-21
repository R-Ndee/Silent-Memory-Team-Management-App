import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/error/not_found_screen.dart';
import '../../screens/member/member_dashboard_screen.dart';
import '../../screens/super_admin/super_admin_dashboard_screen.dart';

/// Provider for GoRouter instance with role-based navigation and authentication redirects.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final profileState = ref.watch(currentUserProfileProvider);

  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (context, state) {
      final isAuthLoading = authState.isLoading;
      final isAuthenticated = authState.asData?.value != null;
      final isProfileLoading = isAuthenticated && profileState.isLoading;
      final isProfileError = isAuthenticated && profileState.hasError;
      final userProfile = profileState.asData?.value;
      final role = userProfile?.role;

      final location = state.matchedLocation;
      final isLoggingIn = location == '/login';

      // 1. Still loading authentication or profile state -> stay on current route
      if (isAuthLoading || isProfileLoading) return null;

      // 2. Unauthenticated user trying to access protected routes -> redirect to /login
      if (!isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      // 3. User authenticated, but profile failed to load (error) or doc missing
      // Do NOT fall back to member dashboard. Stay on current route to show error.
      if (isProfileError || userProfile == null) {
        return isLoggingIn ? null : null;
      }

      // 4. Inactive user check: sign out automatically and block access to all protected routes
      if (userProfile.status == AppConstants.userStatusInactive) {
        ref.read(authServiceProvider).signOut();
        return isLoggingIn ? null : '/login';
      }

      // 5. User authenticated with valid active profile, determine target route based on role
      final defaultRoleLocation = _getDefaultLocationForRole(role);

      // If user is on /login, redirect to their role-specific dashboard
      if (isLoggingIn) {
        return defaultRoleLocation ?? '/login';
      }

      // 5. Role-based Route Protection
      if (location.startsWith('/super-admin') && role != AppConstants.roleSuperAdmin) {
        return defaultRoleLocation ?? '/login';
      }

      if (location.startsWith('/admin') &&
          role != AppConstants.roleAdmin &&
          role != AppConstants.roleSuperAdmin) {
        return defaultRoleLocation ?? '/login';
      }

      if (location.startsWith('/member') &&
          role != AppConstants.roleMember &&
          role != AppConstants.roleAdmin &&
          role != AppConstants.roleSuperAdmin) {
        return defaultRoleLocation ?? '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/member/dashboard',
        builder: (context, state) => const MemberDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/super-admin/dashboard',
        builder: (context, state) => const SuperAdminDashboardScreen(),
      ),
    ],
  );
});

String? _getDefaultLocationForRole(String? role) {
  switch (role) {
    case AppConstants.roleSuperAdmin:
      return '/super-admin/dashboard';
    case AppConstants.roleAdmin:
      return '/admin/dashboard';
    case AppConstants.roleMember:
      return '/member/dashboard';
    default:
      return null;
  }
}

