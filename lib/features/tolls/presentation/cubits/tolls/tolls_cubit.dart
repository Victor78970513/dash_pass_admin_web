import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/models/user_model.dart';
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
  List<String> c1Vehicles = [];
  List<String> c2Vehicles = [];
  List<String> c3Vehicles = [];
  List<String> c4Vehicles = [];
  List<String> c5Vehicles = [];
  List<String> c6Vehicles = [];
  List<String> c7Vehicles = [];

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
        final adminSnapshot = await _firestore
            .collection('administradores')
            .doc(toll.adminId)
            .get();

        if (adminSnapshot.exists) {
          final adminData = UserModel.fromJson(adminSnapshot.data()!);
          toll.adminData = adminData;
        }
      }
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
    } catch (e) {
      print("ERROR AL AGREGAR PEAJE: $e");
      emit(TollsError(message: "ERROR AL AGREGAR PEAJE: $e"));
    }
  }
}
