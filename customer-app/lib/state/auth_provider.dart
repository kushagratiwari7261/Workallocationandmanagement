import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../models/user.dart';
import '../core/supabase.dart';
import '../core/api.dart';

class AuthState {
  final UserModel? user;
  final bool loading;
  final String? error;

  AuthState({this.user, this.loading = false, this.error});

  AuthState copyWith({
    UserModel? user,
    bool? loading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _initListener();
  }

  void _initListener() {
    SupabaseService.authStateChanges.listen((event) {
      if (event.session != null) {
        fetchUserProfile();
      } else {
        state = AuthState(user: null);
      }
    });
  }

  Future<void> fetchUserProfile() async {
    state = state.copyWith(loading: true);
    final response = await ApiClient.get('/api/v1/users/me');
    if (response.error == null && response.data != null) {
      state = state.copyWith(
        user: UserModel.fromJson(response.data as Map<String, dynamic>),
        loading: false,
      );
    } else {
      state = state.copyWith(
        loading: false,
        error: response.error,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await fetchUserProfile();
      return true;
    } on sb.AuthException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Login failed');
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    state = state.copyWith(loading: true);
    try {
      await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      return true;
    } on sb.AuthException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Registration failed');
      return false;
    }
  }

  Future<void> logout() async {
    await SupabaseService.client.auth.signOut();
    state = AuthState(user: null);
  }

  Future<bool> resetPassword(String email) async {
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(email);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
