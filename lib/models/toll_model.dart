class TollModel {
  final String idPeaje;
  final List<Tarifa> tarifas;
  final String userId;
  final String ubicacion;
  final String nombre;

  TollModel({
    required this.idPeaje,
    required this.tarifas,
    required this.userId,
    required this.ubicacion,
    required this.nombre,
  });

  // Métodos para convertir de y a Map
  factory TollModel.fromMap(Map<String, dynamic> map) {
    return TollModel(
      idPeaje: map['id_peaje'] ?? '',
      tarifas: List<Tarifa>.from(
        map['tarifas']?.map((x) => Tarifa.fromMap(x)) ?? [],
      ),
      userId: map['user_id'] ?? '',
      ubicacion: map['ubicacion'] ?? '',
      nombre: map['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_peaje': idPeaje,
      'tarifas': tarifas.map((x) => x.toMap()).toList(),
      'user_id': userId,
      'ubicacion': ubicacion,
      'nombre': nombre,
    };
  }
}

class Tarifa {
  final String tipo;
  final double monto;

  Tarifa({
    required this.tipo,
    required this.monto,
  });

  factory Tarifa.fromMap(Map<String, dynamic> map) {
    return Tarifa(
      tipo: map['tipo'] ?? '',
      monto: map['monto']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'monto': monto,
    };
  }
}
