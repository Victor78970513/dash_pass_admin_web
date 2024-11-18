part of 'vehicles_cubit.dart';

sealed class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object> get props => [];
}

final class VehiclesInitial extends VehiclesState {}

final class VehiclesLoading extends VehiclesState {}

final class VehiclesLoaded extends VehiclesState {
  final List<PaseDetalle> pases;

  const VehiclesLoaded({required this.pases});
}

final class VehiclesError extends VehiclesState {
  final String message;

  const VehiclesError({required this.message});

  @override
  List<Object> get props => [];
}
