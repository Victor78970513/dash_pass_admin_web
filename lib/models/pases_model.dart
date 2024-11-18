import 'package:cloud_firestore/cloud_firestore.dart';

class PasesModel {
  final DateTime createdAt;
  final String uid;
  final String idPeaje;
  final String idUsuario;
  final String idVehiculo;
  final double monto;
  final String payState;

  PasesModel({
    required this.createdAt,
    required this.uid,
    required this.idPeaje,
    required this.idUsuario,
    required this.idVehiculo,
    required this.monto,
    required this.payState,
  });

  factory PasesModel.fromJson(Map<String, dynamic> json) {
    return PasesModel(
      createdAt: (json["fecha_creacion"] as Timestamp).toDate(),
      uid: json['id_pase'],
      idPeaje: json['id_peaje'],
      idUsuario: json['id_usuario'],
      idVehiculo: json['id_vehiculo'],
      monto: json['monto']?.toDouble() ?? 0.0,
      payState: json['pago_estado'],
    );
  }
}
