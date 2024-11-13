import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/config/shared_preferences/preferences.dart';
import 'package:dash_pass_web/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        final CollectionReference reference =
            FirebaseFirestore.instance.collection("administradores");
        final response = await reference.doc(credential.user!.uid).get();
        final user =
            UserModel.fromJson(response.data() as Map<String, dynamic>);
        Preferences().userRolId = user.rolId;
        emit(AuthSucess(uid: credential.user!.uid));
      } else {
        print("error ania");
        emit(AuthError());
      }
    } catch (e) {
      print(e.toString());
      emit(AuthError());
    }
  }
}
