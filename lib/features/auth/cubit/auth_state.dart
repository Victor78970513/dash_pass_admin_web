part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSucess extends AuthState {
  final String uid;

  AuthSucess({required this.uid});
}

final class AuthError extends AuthState {}
