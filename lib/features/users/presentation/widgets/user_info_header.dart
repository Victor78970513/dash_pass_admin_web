import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Nombre
          Expanded(
            flex: 2,
            child: Text(
              "Nombre de usuario",
              style: titleTextStyle,
              textAlign: TextAlign.start,
            ),
          ),
          // Email
          Expanded(
            flex: 2,
            child: Text(
              "Correo electronico",
              style: titleTextStyle,
              textAlign: TextAlign.start,
            ),
          ),
          // Teléfono
          Expanded(
            flex: 2,
            child: Text(
              "Telefono",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          // Rol
          Expanded(
            flex: 2,
            child: Text(
              "Rol",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          // Fecha
          Expanded(
            flex: 2,
            child: Text(
              "Usuario desde",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          // Estado
          Expanded(
            flex: 1,
            child: Text(
              "Estado",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
