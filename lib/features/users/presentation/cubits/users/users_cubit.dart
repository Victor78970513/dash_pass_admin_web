import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int usersQuantity = 0;
  List<UserAppModel> usersToReport = [];

  Future<void> fetchUsers() async {
    emit(UsersLoading());
    _firestore
        .collection("usuarios")
        .orderBy('estado_cuenta', descending: true)
        .orderBy('fecha_creacion', descending: true)
        .snapshots()
        .listen((snapshot) {
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserAppModel.fromMap(data);
      }).toList();
      usersQuantity = users.length;
      usersToReport.addAll(users);
      emit(UsersLoaded(users: users));
    }).onError((error) {
      print("Error al cargar usuarios: $error");
      emit(UsersError(message: "Error al cargar usuarios: $error"));
    });
  }

  Future<void> fetchUsersWithFilters(
    bool? accountState,
    int? rolId,
  ) async {
    emit(UsersLoading());

    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection("usuarios")
          .orderBy('estado_cuenta', descending: true)
          .orderBy('fecha_creacion', descending: true);
      if (accountState != null) {
        query = query.where("estado_cuenta", isEqualTo: accountState);
      }
      if (rolId != null) {
        query = query.where("id_rol", isEqualTo: rolId);
      }

      // Escuchar resultados
      query.snapshots().listen((snapshot) {
        final users = snapshot.docs.map((doc) {
          final data = doc.data();
          return UserAppModel.fromMap(data);
        }).toList();

        usersQuantity = users.length;
        emit(UsersLoaded(users: users));
      }).onError((error) {
        print("Error al cargar usuarios: $error");
        emit(UsersError(message: "Error al cargar usuarios: $error"));
      });
    } catch (error) {
      print("Error en la consulta: $error");
      emit(UsersError(message: "Error en la consulta: $error"));
    }
  }

  Future<void> addUser({
    required int carnet,
    required String email,
    required String name,
    required String password,
    required int phone,
    required int rolId,
  }) async {
    try {
      emit(UsersLoading());
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = credential.user!.uid;
      await Future.delayed(const Duration(milliseconds: 1000));
      final newUser = UserAppModel(
        carnet: carnet,
        email: email,
        acountState: true,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        profilePicture: '',
        rolId: rolId,
        uid: uid,
        vehicleId: '',
        name: name,
        saldo: 0,
        phone: phone,
      );
      await _firestore.collection("usuarios").doc(uid).set(
            newUser.appUserToJson(),
          );
    } catch (e) {
      print("ERROR AL AGREGAR USUARIO: $e");
      emit(UsersError(message: e.toString()));
    }
  }

  Future<void> updateUser({
    required String nombre,
    required int carnet,
    required String correo,
    required String uid,
    required int phone,
    required int rolId,
  }) async {
    emit(UsersLoading());
    await Future.delayed(const Duration(milliseconds: 1000));
    Map<String, dynamic> userData = {
      'nombre': nombre,
      'carnet_identidad': carnet,
      'correo': correo,
      'telefono': phone,
      'id_rol': rolId,
    };
    await _firestore.collection("usuarios").doc(uid).update(userData);
  }

  Future<void> updateUserState(
      {required bool value, required String uid}) async {
    await _firestore.collection("usuarios").doc(uid).update({
      "estado_cuenta": value,
    });
  }
}
