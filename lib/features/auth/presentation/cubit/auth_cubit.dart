import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepository _authRepository;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required AuthRepository authRepository,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _authRepository = authRepository,
       super(const AuthState.initial());

  Future<void> login(String username, String password) async {
    emit(const AuthState.loading());

    final result = await _loginUseCase(username: username, password: password);

    result.when(
      ok: (user) => emit(AuthState.authenticated(user)),
      err: (failure) => emit(AuthState.error(failure.displayMessage)),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(const AuthState.loading());

    final result = await _registerUseCase(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );

    result.when(
      ok: (user) => emit(AuthState.authenticated(user)),
      err: (failure) => emit(AuthState.error(failure.displayMessage)),
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());

    final result = await _authRepository.logout();

    result.when(
      ok: (_) => emit(const AuthState.unauthenticated()),
      err: (failure) => emit(AuthState.error(failure.displayMessage)),
    );
  }

  Future<void> checkAuthStatus() async {
    final result = await _authRepository.getCurrentUser();

    result.when(
      ok: (user) => emit(AuthState.authenticated(user)),
      err: (_) => emit(const AuthState.unauthenticated()),
    );
  }

  void clearError() {
    if (state is AuthError) {
      emit(const AuthState.initial());
    }
  }
}
