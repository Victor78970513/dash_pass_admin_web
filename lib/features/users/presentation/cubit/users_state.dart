part of 'users_cubit.dart';

@immutable
sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<UserAppModel> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

final class UsersError extends UsersState {
  final String message;

  const UsersError({required this.message});

  @override
  List<Object> get props => [message];
}
