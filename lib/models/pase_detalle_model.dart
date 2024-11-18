import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:dash_pass_web/models/vehicles_model.dart';
import 'toll_model.dart';

class PaseDetalle {
  final String idPase;
  final String idPeaje;
  final String idUsuario;
  final String idVehiculo;
  final double monto;
  final String pagoEstado;
  final DateTime fechaCreacion;
  final UserAppModel usuario;
  final VehiculoModel vehiculo;
  final TollModel peaje;

  PaseDetalle({
    required this.idPase,
    required this.idPeaje,
    required this.idUsuario,
    required this.idVehiculo,
    required this.monto,
    required this.pagoEstado,
    required this.fechaCreacion,
    required this.usuario,
    required this.vehiculo,
    required this.peaje,
  });
}
