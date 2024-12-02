import 'dart:async';

import 'package:dash_pass_web/features/tolls/presentation/cubits/map/map_cubit.dart';
import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/admins_toll_widget.dart';
import 'package:dash_pass_web/features/tolls/presentation/widgets/tarifa_widget.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 5),
    blurRadius: 5,
    blurStyle: BlurStyle.inner,
  ),
];

class CreateTollPage extends StatefulWidget {
  static const name = "create-toll";
  const CreateTollPage({super.key});

  @override
  State<CreateTollPage> createState() => _CreateTollPageState();
}

class _CreateTollPageState extends State<CreateTollPage> {
  List<TarifasWidget> tarifas = [];
  List<Tarifa> tarfiasToSend = [];
  final Map<int, Set<String>> selectedVehiclesPerTariff = {};
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  final TextEditingController nameController = TextEditingController();

  void addTarifasWidget() {
    setState(() {
      tarifas.add(
        TarifasWidget(
          title: "Clasificacion ${tarifas.length + 1}",
          controller: TextEditingController(),
          onSelectedVehiclesChanged: (selectedVehicles) {
            selectedVehiclesPerTariff[tarifas.length] = selectedVehicles;
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AdminUidCubit()),
        BlocProvider(create: (context) => MapCubit()),
        BlocProvider(create: (context) => TollsCubit()),
      ],
      child: BlocConsumer<TollsCubit, TollsState>(
        listener: (context, state) {
          if (state is TollAddedState) {
            Navigator.pop(context);
          }
        },
        builder: (context, tollState) {
          return BlocBuilder<MapCubit, LatLng>(
            builder: (context, state) {
              return Container(
                color: const Color(0xffF4F4F4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          "Crear peaje",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: boxShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: CreateTollTextField(
                                      controller: nameController,
                                      title: "Nombre del Peaje",
                                      hintText:
                                          "Ingresa el nombre para el peaje",
                                    ),
                                  )
                                ],
                              ),
                              const AdminListWidget(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "Clasificacion para las tarifas del peaje",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF26374D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ...tarifas,
                              const SizedBox(height: 20),
                              if (tarifas.length < 7) ...[
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () => addTarifasWidget(),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: const Icon(Icons.add),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Agregar Clasificación",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: boxShadow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 30),
                                Text(
                                  "Selecciona la ubicacion para el peaje",
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF26374D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
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
                                            target:
                                                context.read<MapCubit>().state,
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
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: boxShadow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Text(
                                          "Cancelar",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () async {
                                    for (int i = 0; i < tarifas.length; i++) {
                                      final tarifa = tarifas[i];
                                      tarfiasToSend.add(Tarifa(
                                        clasificacion:
                                            (selectedVehiclesPerTariff[i + 1] ??
                                                    {})
                                                .toList(),
                                        monto: double.parse(
                                            tarifa.controller.text),
                                      ));
                                      print(
                                          "Tarifa ${i}: ${tarifa.controller.text}");
                                      print(
                                          "Vehículos seleccionados para $i: ${selectedVehiclesPerTariff[i + 1]}");
                                      print(
                                          "-------------------------------------------");
                                      context.read<TollsCubit>().addToll(
                                            name: nameController.text,
                                            adminId: context
                                                .read<AdminUidCubit>()
                                                .state,
                                            target:
                                                context.read<MapCubit>().state,
                                            tarifas: tarfiasToSend,
                                          );
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color(0xFF1C3C63),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: tollState is TollsLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                "Guardar",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CreateTollTextField extends StatelessWidget {
  final String title;
  final String? hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  String? Function(String?)? validator;
  CreateTollTextField({
    super.key,
    required this.title,
    this.hintText,
    this.obscureText = false,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF26374D),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            validator: validator,
            obscureText: obscureText,
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF26374D),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF26374D)),
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
