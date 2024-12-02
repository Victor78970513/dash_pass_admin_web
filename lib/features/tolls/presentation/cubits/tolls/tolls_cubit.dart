import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/config/shared_preferences/preferences.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'tolls_state.dart';

class AdminUidCubit extends Cubit<String> {
  AdminUidCubit() : super("");

  void changeAdminUid(String value) {
    emit(value);
  }
}

class TollsCubit extends Cubit<TollsState> {
  TollsCubit() : super(TollsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int tollsQuantity = 0;
  String adminUid = "";
  List<TollModel> tollsToReport = [];

  Future<void> fetchTolls() async {
    emit(TollsLoading());
    _firestore
        .collection('peajes')
        .orderBy('fecha_creacion', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final tolls = snapshot.docs.map((doc) {
        final data = doc.data();
        return TollModel.fromMap(data);
      }).toList();
      tollsQuantity = tolls.length;
      for (var toll in tolls) {
        final adminSnapshot =
            await _firestore.collection('usuarios').doc(toll.adminId).get();

        if (adminSnapshot.exists) {
          final adminData = UserAppModel.fromMap(adminSnapshot.data()!);
          toll.adminData = adminData;
        }
      }
      tollsToReport.addAll(tolls);
      emit(TollsLoaded(tolls: tolls));
    }).onError((error) {
      print("Error al traer los peajes: $error");
      emit(TollsError(message: "Error al traer los peajes: $error"));
    });
  }

  Future<void> fetchTollsWithAdmin() async {
    final userId = Preferences().userUUID;
    emit(TollsLoading());
    _firestore
        .collection('peajes')
        .where("id_administrador", isEqualTo: userId)
        .orderBy('fecha_creacion', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final tolls = snapshot.docs.map((doc) {
        final data = doc.data();
        return TollModel.fromMap(data);
      }).toList();
      tollsQuantity = tolls.length;
      for (var toll in tolls) {
        final adminSnapshot =
            await _firestore.collection('usuarios').doc(toll.adminId).get();

        if (adminSnapshot.exists) {
          final adminData = UserAppModel.fromMap(adminSnapshot.data()!);
          toll.adminData = adminData;
        }
      }
      tollsToReport.addAll(tolls);
      emit(TollsLoaded(tolls: tolls));
    }).onError((error) {
      print("Error al traer los peajes: $error");
      emit(TollsError(message: "Error al traer los peajes: $error"));
    });
  }

  Future<void> addToll({
    required String name,
    required String adminId,
    required LatLng target,
    required List<Tarifa> tarifas,
  }) async {
    try {
      final idPeaje = FirebaseFirestore.instance.collection('peajes').doc().id;
      emit(TollsLoading());
      await Future.delayed(const Duration(milliseconds: 1000));
      final newToll = TollModel(
        idPeaje: idPeaje,
        tarifas: tarifas,
        adminId: adminId,
        latitud: target.latitude,
        longitud: target.longitude,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firestore
          .collection('peajes')
          .doc(idPeaje)
          .set(newToll.tollToMap());

      emit(TollAddedState());
    } catch (e) {
      print("ERROR AL AGREGAR PEAJE: $e");
      emit(TollsError(message: "ERROR AL AGREGAR PEAJE: $e"));
    }
  }

  Future<void> editToll({
    required String idPeaje,
    required String name,
    required String adminId,
    required LatLng target,
    required List<Tarifa> tarifas,
  }) async {
    try {
      emit(TollsLoading());
      await Future.delayed(const Duration(milliseconds: 1000));

      // Obtenemos el peaje actual desde Firestore
      final tollRef = _firestore.collection('peajes').doc(idPeaje);

      // Creamos el objeto actualizado
      final updatedToll = TollModel(
        idPeaje: idPeaje,
        tarifas: tarifas,
        adminId: adminId,
        latitud: target.latitude,
        longitud: target.longitude,
        name: name,
        createdAt: DateTime
            .now(), // Puedes mantener la fecha de creación, o decidir si la actualizas
        updatedAt: DateTime.now(),
      );

      // Actualizamos el documento en Firestore
      await tollRef.update(updatedToll.tollToMap());

      emit(TollAddedState());
    } catch (e) {
      print("ERROR AL EDITAR PEAJE: $e");
      emit(TollsError(message: "ERROR AL EDITAR PEAJE: $e"));
    }
  }
}
