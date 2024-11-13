import 'package:cloud_firestore/cloud_firestore.dart';

class UserAppModel {
  final String name;
  final String email;
  final String uid;
  final String tarjetaId;
  final String vehiculoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double saldo;
  final String profilePictureUrl;
  final int carnetIdentidad;
  final bool isActive;

  UserAppModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.tarjetaId,
    required this.saldo,
    required this.vehiculoId,
    required this.profilePictureUrl,
    required this.carnetIdentidad,
    required this.isActive,
  });

  factory UserAppModel.fromMap(Map<String, dynamic> map) {
    return UserAppModel(
      name: map["name"],
      email: map["email"],
      uid: map["uid"],
      createdAt: (map["createdAt"] as Timestamp).toDate(),
      updatedAt: (map["updatedAt"] as Timestamp).toDate(),
      tarjetaId: map["tarjeta_id"],
      saldo: (map["saldo"] as int).toDouble(),
      vehiculoId: map["vehiculo_id"],
      profilePictureUrl: map["profile_picture_url"],
      carnetIdentidad: map["carnet_identidad"],
      isActive: map["activo"],
    );
  }
}
