import 'package:cloud_firestore/cloud_firestore.dart';

class UserAppModel {
  final int carnet;
  final String email;
  final bool acountState;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String profilePicture;
  final int rolId;
  final String uid;
  final String vehicleId;
  final String name;
  final double saldo;

  UserAppModel({
    required this.carnet,
    required this.email,
    required this.acountState,
    required this.updatedAt,
    required this.createdAt,
    required this.profilePicture,
    required this.rolId,
    required this.uid,
    required this.vehicleId,
    required this.name,
    required this.saldo,
  });

  factory UserAppModel.fromMap(Map<String, dynamic> json) {
    return UserAppModel(
      carnet: json['carnet_identidad'],
      email: json['correo'],
      acountState: json['estado_cuenta'],
      updatedAt: (json['fecha_actualizacion'] as Timestamp).toDate(),
      createdAt: (json['fecha_creacion'] as Timestamp).toDate(),
      profilePicture: json['foto_perfil'],
      rolId: json['id_rol'],
      uid: json['id_usuario'],
      vehicleId: json['id_vehiculo'],
      name: json['nombre'],
      saldo: json['saldo']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> appUserToJson() => {
        'carnet_identidad': carnet,
        'correo': email,
        'estado_cuenta': acountState,
        'fecha_actualizacion': updatedAt,
        'fecha_creacion': createdAt,
        'foto_perfil': profilePicture,
        'id_rol': rolId,
        'id_usuario': uid,
        'id_vehiculo': vehicleId,
        'nombre': name,
        'saldo': saldo,
      };
}
