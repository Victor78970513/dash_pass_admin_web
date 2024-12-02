import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/config/shared_preferences/preferences.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
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
            FirebaseFirestore.instance.collection("usuarios");
        final response = await reference.doc(credential.user!.uid).get();
        final user =
            UserAppModel.fromMap(response.data() as Map<String, dynamic>);
        Preferences().userRolId = user.rolId;
        Preferences().userUUID = user.uid;
        emit(AuthSucess(uid: credential.user!.uid));
      } else {
        print("error ania");
        emit(AuthError());
      }
    } catch (e) {
      print("EL ERROR AL INICIAR SESION ES: $e");
      emit(AuthError());
    }
  }

  void sendOtp(
    String phoneNumber,
    Function(PhoneAuthCredential verificationCompleted) onVerificationCompleted,
    Function(Function(FirebaseAuthException)) onVerificationFailed,
    Function(String verificationId, int? forceResendingToken) onCodeSent,
  ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: onVerificationCompleted,
      verificationFailed: (a) {},
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
