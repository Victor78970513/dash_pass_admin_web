import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TarifasWidget extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final List<String> vehicleList;
  final List<String> selectedVehicles;
  final Function(String) onChanged;

  const TarifasWidget({
    Key? key,
    required this.controller,
    required this.title,
    required this.vehicleList,
    required this.onChanged,
    required this.selectedVehicles,
  }) : super(key: key);

  @override
  State<TarifasWidget> createState() => _TarifasWidgetState();
}

class _TarifasWidgetState extends State<TarifasWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
        collapsedBackgroundColor: Colors.transparent,
        iconColor: const Color(0xFF2C3E50),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ExpansionTile(
                  title: Text(
                    "Seleccione los vehículos",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.1),
                  collapsedBackgroundColor: Colors.transparent,
                  iconColor: const Color(0xFF2C3E50),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: List.generate(
                          widget.vehicleList.length,
                          (index) =>
                              _buildVehicleListTile(widget.vehicleList[index]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
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
                          borderSide:
                              const BorderSide(color: Color(0xFF3498DB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFF2C3E50)),
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleListTile(String vehicle) {
    final isSelected = widget.selectedVehicles.contains(vehicle);
    return ListTile(
      title: Text(
        vehicle,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: isSelected ? const Color(0xFF1C3C63) : const Color(0xFF2C3E50),
        ),
      ),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isSelected ? const Color(0xFF1C3C63) : Colors.black,
      ),
      onTap: () {
        setState(() {
          if (isSelected) {
            widget.selectedVehicles.remove(vehicle);
          } else {
            widget.onChanged(vehicle);
          }
        });
      },
    );
  }
}
