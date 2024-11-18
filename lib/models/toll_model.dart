import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/models/user_model.dart';

class TollModel {
  final String idPeaje;
  final String adminId;
  final double latitud;
  final double longitud;
  final String name;
  final List<Tarifa> tarifas;
  final DateTime createdAt;
  final DateTime updatedAt;
  UserModel? adminData;

  TollModel({
    required this.idPeaje,
    required this.tarifas,
    required this.adminId,
    required this.latitud,
    required this.longitud,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.adminData,
  });

  // Métodos para convertir de y a Map
  factory TollModel.fromMap(Map<String, dynamic> map) {
    return TollModel(
      idPeaje: map['id_peaje'],
      tarifas: (map['tarifas'] as List<dynamic>)
          .map((item) => Tarifa.fromMap(item))
          .toList(),
      adminId: map['id_administrador'],
      latitud: map['latitud']?.toDouble() ?? 0.0,
      longitud: map['longitud']?.toDouble() ?? 0.0,
      name: map['nombre'],
      createdAt: (map['fecha_creacion'] as Timestamp).toDate(),
      updatedAt: (map['fecha_actualizacion'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> tollToMap() {
    return {
      'fecha_actualizacion': updatedAt,
      'fecha_creacion': createdAt,
      'id_administrador': adminId,
      'id_peaje': idPeaje,
      'latitud': latitud,
      'longitud': longitud,
      'nombre': name,
      'tarifas': tarifas.map((tarifa) => tarifa.toMap()).toList()
    };
  }
}

class Tarifa {
  final List<String> clasificacion;
  final double monto;

  Tarifa({
    required this.clasificacion,
    required this.monto,
  });

  factory Tarifa.fromMap(Map<String, dynamic> map) {
    return Tarifa(
      clasificacion: List<String>.from(map['clasificacion'] ?? []),
      monto: map['monto']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clasificacion': clasificacion,
      'monto': monto,
    };
  }
}
