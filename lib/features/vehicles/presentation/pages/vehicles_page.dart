import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/features/vehicles/presentation/widgets/pase_detalle_card.dart';
import 'package:dash_pass_web/features/vehicles/presentation/widgets/vehicles_loading_shimmer.dart';
import 'package:dash_pass_web/main.dart';
import 'package:dash_pass_web/models/pase_detalle_model.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:dash_pass_web/models/vehicles_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VehiclesPage extends StatefulWidget {
  static const name = '/vehicles-page';
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromRGBO(244, 243, 253, 1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Monitoreo Vehicular",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                const Spacer(),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.black54),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Buscar por placa",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pases')
                  .orderBy('fecha_creacion', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Error al traer la data de pases: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No hay datos disponibles."),
                  );
                }

                final paseDetalles = snapshot.data!.docs.map((doc) async {
                  final data = doc.data() as Map<String, dynamic>;
                  final usuario = await fetchUsuario(data['id_usuario']);
                  final vehiculo = await fetchVehiculo(data['id_vehiculo']);
                  final peaje = await fetchPeaje(data['id_peaje']);

                  return PaseDetalle(
                    idPase: data['id_pase'],
                    idPeaje: data['id_peaje'],
                    idUsuario: data['id_usuario'],
                    idVehiculo: data['id_vehiculo'],
                    monto: data['monto'].toDouble(),
                    pagoEstado: data['pago_estado'],
                    fechaCreacion:
                        (data['fecha_creacion'] as Timestamp).toDate(),
                    usuario: usuario,
                    vehiculo: vehiculo,
                    peaje: peaje,
                  );
                }).toList();

                // Esperar a que todos los futuros se completen
                return FutureBuilder<List<PaseDetalle>>(
                  future: Future.wait(paseDetalles),
                  builder: (context, paseSnapshot) {
                    if (paseSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const VehiclesLoadingShimmer();
                    }

                    if (paseSnapshot.hasError) {
                      return Center(
                        child: Text(
                            "Error al procesar datos: ${paseSnapshot.error}"),
                      );
                    }

                    if (paseSnapshot.hasData) {
                      pasesToReport.clear();
                      pasesToReport.addAll(paseSnapshot.data!);
                      final pases = paseSnapshot.data!;
                      final filteredPases = pases
                          .where((pase) => pase.vehiculo.placa
                              .toLowerCase()
                              .contains(searchQuery))
                          .toList();
                      if (filteredPases.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            children:
                                List.generate(filteredPases.length, (index) {
                              final paseDetalle = filteredPases[index];
                              return PaseDetalleCard(paseDetalle: paseDetalle);
                            }),
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text("No hay pases con esa placa"));
                      }
                    } else {
                      return const Center(
                          child: Text("No hay datos para mostrar"));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<UserAppModel> fetchUsuario(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();
    if (userDoc.exists) {
      return UserAppModel.fromMap(userDoc.data()!);
    }
    throw Exception('Usuario no encontrado');
  }

  Future<VehiculoModel> fetchVehiculo(String vehiculoId) async {
    final vehiculoDoc = await FirebaseFirestore.instance
        .collection('vehiculos')
        .doc(vehiculoId)
        .get();
    if (vehiculoDoc.exists) {
      return VehiculoModel.fromJson(vehiculoDoc.data()!);
    }
    throw Exception('Vehículo no encontrado');
  }

  Future<TollModel> fetchPeaje(String peajeId) async {
    final peajeDoc = await FirebaseFirestore.instance
        .collection('peajes')
        .doc(peajeId)
        .get();
    if (peajeDoc.exists) {
      return TollModel.fromMap(peajeDoc.data()!);
    }
    throw Exception('Peaje no encontrado');
  }
}
