import 'package:flutter/material.dart';
import 'package:dash_pass_web/models/pase_detalle_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PaseDetalleCard extends StatelessWidget {
  final PaseDetalle paseDetalle;

  const PaseDetalleCard({
    super.key,
    required this.paseDetalle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1C3C63), Color(0xFF2A4B74)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoGrid(context),
                    const SizedBox(height: 16),
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6186A6), Color(0xFF8C9BB9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pase ID: ${paseDetalle.idPase}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
          _buildStatusChip(context),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth > 600
            ? _buildTwoColumnGrid(context)
            : _buildOneColumnGrid(context);
      },
    );
  }

  Widget _buildOneColumnGrid(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(
            context, Icons.person, "Usuario", paseDetalle.usuario.name),
        _buildInfoRow(context, Icons.credit_card, "Carnet",
            paseDetalle.usuario.carnet.toString()),
        _buildInfoRow(context, Icons.directions_car, "Vehículo",
            "${paseDetalle.vehiculo.marca} ${paseDetalle.vehiculo.modelo}"),
        _buildInfoRow(context, Icons.confirmation_number, "Placa",
            paseDetalle.vehiculo.placa),
        _buildInfoRow(
            context, Icons.category, "Tipo", paseDetalle.vehiculo.tipoVehiculo),
        _buildInfoRow(context, Icons.toll, "Peaje", paseDetalle.peaje.name),
      ],
    );
  }

  Widget _buildTwoColumnGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInfoRow(
                  context, Icons.person, "Usuario", paseDetalle.usuario.name),
              _buildInfoRow(context, Icons.credit_card, "Carnet",
                  paseDetalle.usuario.carnet.toString()),
              _buildInfoRow(context, Icons.directions_car, "Vehículo",
                  "${paseDetalle.vehiculo.marca} ${paseDetalle.vehiculo.modelo}"),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildInfoRow(context, Icons.confirmation_number, "Placa",
                  paseDetalle.vehiculo.placa),
              _buildInfoRow(context, Icons.category, "Tipo",
                  paseDetalle.vehiculo.tipoVehiculo),
              _buildInfoRow(
                  context, Icons.toll, "Peaje", paseDetalle.peaje.name),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.white), // Azul moderado
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAmountDisplay(context),
        _buildDateDisplay(context),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: paseDetalle.pagoEstado == "exitoso"
            ? const Color(0xFF66BB6A) // Verde suave
            : const Color(0xFFE57373), // Rojo suave
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        paseDetalle.pagoEstado.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
      ),
    );
  }

  Widget _buildAmountDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFB3D9FF), // Azul suave para fondo
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_money,
              size: 22, color: Color(0xFF2F73A1)), // Azul moderado
          const SizedBox(width: 4),
          Text(
            "Bs ${paseDetalle.monto.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF2F73A1), // Azul para texto
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDisplay(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy HH:mm').format(paseDetalle.fechaCreacion);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.access_time, size: 28, color: Colors.white),
        const SizedBox(width: 10),
        Text(
          formattedDate,
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24),
        ),
      ],
    );
  }
}
