import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'core/supabase.dart';
import 'core/storage.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/tab_container.dart';
import 'screens/booking_workflow_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/referral_screen.dart';
import 'screens/workla_gold_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/addresses_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cached local storage
  await LocalCache.init();

  // Initialize Supabase integrations
  await SupabaseService.init();

  runApp(
    const ProviderScope(
      child: WorklaApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const TabContainer(),
    ),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BookingWorkflowScreen(serviceId: id);
      },
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChatScreen(bookingId: id);
      },
    ),
    GoRoute(
      path: '/track/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TrackingScreen(bookingId: id);
      },
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/referral',
      builder: (context, state) => const ReferralScreen(),
    ),
    GoRoute(
      path: '/workla-gold',
      builder: (context, state) => const WorklaGoldScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/addresses',
      builder: (context, state) => const AddressesScreen(),
    ),
  ],
);

class WorklaApp extends StatelessWidget {
  const WorklaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Workla',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
