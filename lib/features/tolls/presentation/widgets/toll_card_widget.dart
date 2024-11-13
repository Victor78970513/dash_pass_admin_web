import 'package:dash_pass_web/models/toll_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class TollCardWidget extends StatelessWidget {
  final TollModel toll;
  const TollCardWidget({super.key, required this.toll});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Container(
        // height: size.height * 0.4,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff6A4CFF), Color(0xff8A7CBE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            // Nombre del peaje
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('administradores')
                  .doc(toll.userId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!.exists) {
                  return const Text(
                    "Encargado no disponible",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
                }

                final adminData = UserModel.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);

                return Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundImage: adminData.profilePicture.isNotEmpty
                            ? NetworkImage(adminData.profilePicture)
                                as ImageProvider
                            : const AssetImage(
                                "assets/images/no_profile_image.jpg"),
                        radius: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ENCARGADO: ${adminData.name}",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "CORREO: ${adminData.correo}",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.amber,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nombre: ${toll.nombre}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...List.generate(
                      toll.tarifas.length,
                      (index) {
                        final tarifa = toll.tarifas[index];
                        return Text(
                          "${tarifa.tipo}: Bs. ${tarifa.monto}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
