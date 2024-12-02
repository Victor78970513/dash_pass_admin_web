part of 'tolls_cubit.dart';

sealed class TollsState extends Equatable {
  const TollsState();

  @override
  List<Object> get props => [];
}

final class TollsInitial extends TollsState {}

final class TollsLoading extends TollsState {}

final class TollAddedState extends TollsState {}

final class TollsLoaded extends TollsState {
  final List<TollModel> tolls;

  const TollsLoaded({required this.tolls});

  @override
  List<Object> get props => [tolls];
}

final class TollsError extends TollsState {
  final String message;

  const TollsError({required this.message});

  @override
  List<Object> get props => [message];
}
