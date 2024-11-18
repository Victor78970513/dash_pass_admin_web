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

  Future<void> fetchUsers() async {
    emit(UsersLoading());
    _firestore
        .collection("usuarios")
        .orderBy('fecha_creacion', descending: true)
        .where('estado_cuenta', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
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
  }

  Future<void> addUser({
    required int carnet,
    required String email,
    required String name,
    required String password,
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
        rolId: 4,
        uid: uid,
        vehicleId: '',
        name: name,
        saldo: 0,
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
    required double saldo,
    required int carnet,
    required String correo,
    required String uid,
  }) async {
    emit(UsersLoading());
    await Future.delayed(const Duration(milliseconds: 1000));
    Map<String, dynamic> userData = {
      'nombre': nombre,
      'saldo': saldo,
      'carnet_identidad': carnet,
      'correo': correo,
    };
    await _firestore.collection("usuarios").doc(uid).update(userData);
  }
}
