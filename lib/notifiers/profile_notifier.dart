import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;

  ProfileState({this.user, this.isLoading = false, this.error});

  ProfileState copyWith({User? user, bool? isLoading, String? error}) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final AuthService _authService;
  ProfileNotifier(this._authService) : super(ProfileState());

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> updateProfile(User updatedUser) async {
    if (updatedUser.shopId == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.updateProfile(
        updatedUser.shopId!,
        updatedUser,
      );
      if (response.statusCode == 200) {
        final user = User.fromMap(response.data);
        state = state.copyWith(user: user, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
