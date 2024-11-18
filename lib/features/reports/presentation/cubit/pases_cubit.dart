import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/models/pases_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'pases_state.dart';

class PasesCubit extends Cubit<PasesState> {
  PasesCubit() : super(PasesInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double ingresosTotales = 0.0;

  Future<void> fetchPases() async {
    ingresosTotales = 0;
    emit(PasesLoading());
    try {
      _firestore
          .collection('pases')
          .orderBy('fecha_creacion', descending: false)
          .snapshots()
          .listen((snapshot) {
        final pases = snapshot.docs.map((doc) {
          final data = doc.data();
          final newPase = PasesModel.fromJson(data);
          ingresosTotales = ingresosTotales + newPase.monto;
          return newPase;
        }).toList();
        emit(PasesLoaded(pases: pases));
      }).onError((error) {
        print("ONERROR fetchPases: $error");
        emit(PasesError(message: error));
      });
    } catch (e) {
      print("ERROR al traer los pases $e");
      emit(PasesError(message: e.toString()));
    }
  }
}
