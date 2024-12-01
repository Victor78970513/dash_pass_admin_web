part of 'filter_users_cubit.dart';

class FilterUsersState {
  final String accountState;
  final int? roleId;

  FilterUsersState({
    this.accountState = "Todos",
    this.roleId,
  });

  FilterUsersState copyWith({
    String? accountState,
    int? roleId,
  }) {
    return FilterUsersState(
      accountState: accountState ?? this.accountState,
      roleId: roleId ?? this.roleId,
    );
  }
}
