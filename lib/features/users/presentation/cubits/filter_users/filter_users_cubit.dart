import 'package:flutter_bloc/flutter_bloc.dart';
part 'filter_users_state.dart';

class FilterUsersCubit extends Cubit<FilterUsersState> {
  FilterUsersCubit() : super(FilterUsersState());

  void updateAccountState(String accountState) {
    emit(state.copyWith(accountState: accountState));
  }

  void updateRole(int roleId) {
    emit(state.copyWith(roleId: roleId));
  }

  void resetFilters() {
    emit(FilterUsersState());
  }
}
