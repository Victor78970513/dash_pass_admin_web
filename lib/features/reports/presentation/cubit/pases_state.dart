part of 'pases_cubit.dart';

sealed class PasesState extends Equatable {
  const PasesState();

  @override
  List<Object> get props => [];
}

final class PasesInitial extends PasesState {}

final class PasesLoading extends PasesState {}

final class PasesLoaded extends PasesState {
  final List<PasesModel> pases;

  const PasesLoaded({required this.pases});

  @override
  List<Object> get props => [pases];
}

final class PasesError extends PasesState {
  final String message;

  const PasesError({required this.message});

  @override
  List<Object> get props => [message];
}
