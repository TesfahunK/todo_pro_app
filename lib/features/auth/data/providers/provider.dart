import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_pro/features/auth/data/providers/types.dart';

final authStateProvider =
    StateNotifierProvider<AuthProvider, AuthState>((ref) => AuthProvider());

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider() : super(AuthState()) {
    readAuthState();
  }

  /// the following method reads the app auth state from the saved values on
  /// the device , it basically starts with initial value of [AuthState]

  Future<SharedPreferences> shared_preference() {
    return SharedPreferences.getInstance();
  }

  Future readAuthState() async {
    SharedPreferences preferences = await shared_preference();

// read the saved values
    final bool authEnabled = preferences.getBool("auth_enabled") ?? false;
    final bool? initialLaunch = preferences.getBool("is_initial");

    await Future.delayed(const Duration(seconds: 3));

    if (initialLaunch == null) {
      state = state.copyWith(initial: true, loading: false);
    } else {
      if (authEnabled) {
        state = state.copyWith(loading: false, authenticated: false);
      } else {
        state = state.copyWith(loading: false, authenticated: true);
      }
    }
  }

  void setAuthenticated() {
    state = state.copyWith(authenticated: true);
  }

  Future setLocalAuth(bool choice) async {
    SharedPreferences preferences = await shared_preference();

    await preferences.setBool("auth_enabled", choice);
  }

  void setOnboardingFinished() => state = state.copyWith(initial: false);
}