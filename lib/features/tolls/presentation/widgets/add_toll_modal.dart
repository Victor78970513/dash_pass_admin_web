import 'dart:async';
import 'package:dash_pass_web/features/tolls/presentation/cubits/map/map_cubit.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/admins_toll_widget.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/tarifa_widget.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<String> vehicleList = [
  'Camioneta',
  'Minibus',
  'Micro',
  'Bus',
  'Camion',
  'Volqueta',
  'Camion de 3 Ejes',
  'Camion de 4 Ejes',
  'Camion de 5 Ejes',
  'Camion de 6 Ejes',
  'Camion de 7 Ejes'
];

class AddTollModal extends StatefulWidget {
  const AddTollModal({super.key});

  @override
  State<AddTollModal> createState() => _AddTollModalState();
}

class _AddTollModalState extends State<AddTollModal> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final Completer<GoogleMapController> mapController =
        Completer<GoogleMapController>();
    final TextEditingController nameController = TextEditingController();

    // Clasificacion 1
    final TextEditingController c1TarifaController = TextEditingController();

    // Clasificacion 2
    final TextEditingController c2TarifaController = TextEditingController();

    // Clasificacion 3
    final TextEditingController c3TarifaController = TextEditingController();

    // Clasificacion 4
    final TextEditingController c4TarifaController = TextEditingController();

    // Clasificacion 5
    final TextEditingController c5TarifaController = TextEditingController();

    // Clasificacion 6
    final TextEditingController c6TarifaController = TextEditingController();

    // Clasificacion 7
    final TextEditingController c7TarifaController = TextEditingController();

    final tollsCubit = context.watch<TollsCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AdminUidCubit()),
        BlocProvider(create: (context) => MapCubit())
      ],
      child: BlocBuilder<TollsCubit, TollsState>(
        builder: (context, state) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            // backgroundColor: const Color(0xFF7FB3D5),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.4,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Agregar Peaje",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color:
                              const Color(0xFF2C3E50), // Dark blue for contrast
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              hintText: "Introduzca el nombre del peaje",
                              title: "Nombre del Peaje",
                              controller: nameController,
                              icon: Icons.toll,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "El nombre no puede estar vacío";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.black, width: 1.25)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: context.read<MapCubit>().state,
                                        zoom: 14,
                                      ),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        mapController.complete(controller);
                                      },
                                      onCameraMove: (position) {
                                        context
                                            .read<MapCubit>()
                                            .changeLatLng(position.target);
                                      },
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Seleccione un Administrador",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF2C3E50),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ADMINISTRADORES
                            const AdminListWidget(),
                            // ADMINISTRADORES

                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tarifas de Peaje",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF2C3E50),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Clasificacion 1
                            TarifasWidget(
                              controller: c1TarifaController,
                              title: "Clasificacion 1",
                              vehicleList: vehicleList,
                              selectedVehicles: tollsCubit.c1Vehicles,
                              onChanged: (vehicle) {
                                tollsCubit.c1Vehicles.add(vehicle);
                              },
                            ),

                            // Clasificacion 2
                            TarifasWidget(
                                controller: c2TarifaController,
                                title: "Clasificacion 2",
                                vehicleList: vehicleList,
                                selectedVehicles: tollsCubit.c2Vehicles,
                                onChanged: (vehicle) {
                                  tollsCubit.c2Vehicles.add(vehicle);
                                }),

                            // Clasificacion 3
                            TarifasWidget(
                                controller: c3TarifaController,
                                title: "Clasificacion 3",
                                vehicleList: vehicleList,
                                selectedVehicles: tollsCubit.c3Vehicles,
                                onChanged: (vehicle) {
                                  tollsCubit.c3Vehicles.add(vehicle);
                                }),

                            // Clasificacion 4
                            TarifasWidget(
                                controller: c4TarifaController,
                                title: "Clasificacion 4",
                                vehicleList: vehicleList,
                                selectedVehicles: tollsCubit.c4Vehicles,
                                onChanged: (vehicle) {
                                  tollsCubit.c4Vehicles.add(vehicle);
                                }),

                            // Clasificacion 5
                            TarifasWidget(
                                controller: c5TarifaController,
                                title: "Clasificacion 5",
                                vehicleList: vehicleList,
                                selectedVehicles: tollsCubit.c5Vehicles,
                                onChanged: (vehicle) {
                                  tollsCubit.c5Vehicles.add(vehicle);
                                }),

                            // Clasificacion 6
                            TarifasWidget(
                                controller: c6TarifaController,
                                title: "Clasificacion 6",
                                vehicleList: vehicleList,
                                selectedVehicles: tollsCubit.c6Vehicles,
                                onChanged: (vehicle) {
                                  tollsCubit.c6Vehicles.add(vehicle);
                                }),

                            // Clasificacion 7
                            TarifasWidget(
                                controller: c7TarifaController,
                                title: "Clasificacion 7",
                                vehicleList: vehicleList,
                                selectedVehicles: tollsCubit.c7Vehicles,
                                onChanged: (vehicle) {
                                  tollsCubit.c7Vehicles.add(vehicle);
                                }),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: const Color(0xFF34495E),
                                      width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Cancelar",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: const Color(0xFF2C3E50),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF34495E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final List<Tarifa> tarifas = [
                                  Tarifa(
                                      clasificacion: tollsCubit.c1Vehicles,
                                      monto: double.parse(
                                          c1TarifaController.text)),
                                  Tarifa(
                                      clasificacion: tollsCubit.c2Vehicles,
                                      monto: double.parse(
                                          c2TarifaController.text)),
                                  Tarifa(
                                      clasificacion: tollsCubit.c3Vehicles,
                                      monto: double.parse(
                                          c3TarifaController.text)),
                                  Tarifa(
                                      clasificacion: tollsCubit.c4Vehicles,
                                      monto: double.parse(
                                          c4TarifaController.text)),
                                  Tarifa(
                                      clasificacion: tollsCubit.c5Vehicles,
                                      monto: double.parse(
                                          c5TarifaController.text)),
                                  Tarifa(
                                      clasificacion: tollsCubit.c6Vehicles,
                                      monto: double.parse(
                                          c6TarifaController.text)),
                                  Tarifa(
                                      clasificacion: tollsCubit.c7Vehicles,
                                      monto: double.parse(
                                          c7TarifaController.text)),
                                ];
                                context.read<TollsCubit>().addToll(
                                      name: nameController.text,
                                      adminId:
                                          context.read<AdminUidCubit>().state,
                                      target: context.read<MapCubit>().state,
                                      tarifas: tarifas,
                                    );
                                Navigator.pop(context);
                              }
                            },
                            child: state is TollsLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    "Guardar",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF2C3E50),
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C3E50),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: icon != null
                  ? Icon(icon, color: const Color(0xFF34495E))
                  : null,
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 1.25),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2C3E50)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
