import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class TarifasWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final ValueChanged<Set<String>> onSelectedVehiclesChanged;
  final List<String>? olderVehicles;

  const TarifasWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.onSelectedVehiclesChanged,
    this.olderVehicles,
  });

  @override
  State<TarifasWidget> createState() => _TarifasWidgetState();
}

class _TarifasWidgetState extends State<TarifasWidget> {
  final Set<String> _selectedVehicles = {};

  @override
  void initState() {
    if (widget.olderVehicles != null &&
        (widget.olderVehicles ?? []).isNotEmpty) {
      _selectedVehicles.addAll(widget.olderVehicles!.toSet());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: const Color(0xFF2C3E50), width: 1),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        "Seleccione los vehículos",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                      iconColor: const Color(0xFF2C3E50),
                      children: vehicleList.map((vehicle) {
                        final isSelected = _selectedVehicles.contains(vehicle);
                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(
                            vehicle,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: isSelected
                                  ? const Color(0xFF1C3C63)
                                  : const Color(0xFF2C3E50),
                            ),
                          ),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedVehicles.add(vehicle);
                              } else {
                                _selectedVehicles.remove(vehicle);
                              }
                              widget
                                  .onSelectedVehiclesChanged(_selectedVehicles);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Campo para el monto de la tarifa
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF2C3E50),
                    ),
                    decoration: InputDecoration(
                      hintText: "Introduzca el precio",
                      prefixIcon: const Icon(Icons.attach_money,
                          color: Color(0xFF34495E)),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "La tarifa no puede estar vacía";
                      }
                      if (double.tryParse(value) == null) {
                        return "Ingrese un número válido";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
