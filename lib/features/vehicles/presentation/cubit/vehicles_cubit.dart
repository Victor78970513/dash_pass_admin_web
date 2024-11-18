import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/models/pase_detalle_model.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:dash_pass_web/models/vehicles_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  VehiclesCubit() : super(VehiclesInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchPases() {
    emit(VehiclesLoading());

    _firestore
        .collection('pases')
        .orderBy('fecha_creacion', descending: true)
        .snapshots()
        .listen((snapshot) async {
      try {
        final paseDetalles = await Future.wait(
          snapshot.docs.map((doc) async {
            final data = doc.data();
            final usuario = await _fetchUsuario(data['id_usuario']);
            final vehiculo = await _fetchVehiculo(data['id_vehiculo']);
            final peaje = await _fetchPeaje(data['id_peaje']);
            return PaseDetalle(
              idPase: data['id_pase'],
              idPeaje: data['id_peaje'],
              idUsuario: data['id_usuario'],
              idVehiculo: data['id_vehiculo'],
              monto: data['monto'].toDouble(),
              pagoEstado: data['pago_estado'],
              fechaCreacion: (data['fecha_creacion'] as Timestamp).toDate(),
              usuario: usuario,
              vehiculo: vehiculo,
              peaje: peaje,
            );
          }).toList(),
        );

        emit(VehiclesLoaded(pases: paseDetalles));
      } catch (e) {
        emit(VehiclesError(message: e.toString()));
      }
    }, onError: (error) {
      emit(VehiclesError(message: error.toString()));
    });
  }

  Future<UserAppModel> _fetchUsuario(String userId) async {
    final userDoc = await _firestore.collection('usuarios').doc(userId).get();
    if (userDoc.exists) {
      return UserAppModel.fromMap(userDoc.data()!);
    }
    throw Exception('Usuario no encontrado');
  }

  Future<VehiculoModel> _fetchVehiculo(String vehiculoId) async {
    final vehiculoDoc =
        await _firestore.collection('vehiculos').doc(vehiculoId).get();
    if (vehiculoDoc.exists) {
      return VehiculoModel.fromJson(vehiculoDoc.data()!);
    }
    throw Exception('Vehículo no encontrado');
  }

  Future<TollModel> _fetchPeaje(String peajeId) async {
    final peajeDoc = await _firestore.collection('peajes').doc(peajeId).get();
    if (peajeDoc.exists) {
      return TollModel.fromMap(peajeDoc.data()!);
    }
    throw Exception('Peaje no encontrado');
  }
}
