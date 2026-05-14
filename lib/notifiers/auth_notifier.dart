import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  AuthNotifier(this._authService) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(email, password);
      if (response.statusCode == 200) {
        final userData = response.data['shop'];
        // Fetch full shop details to get all fields
        final fullDetailsResponse = await _authService.getShopById(
          userData['shop_id'],
        );
        final user = User.fromMap(fullDetailsResponse.data);
        state = state.copyWith(user: user, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signup(User user) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.signup(user);
      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = AuthState();
  }
}
