import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:dash_pass_web/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminListWidget extends StatelessWidget {
  const AdminListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width * 0.35.clamp(200.0, 400.0),
      child: FutureBuilder(
        future: FirebaseFirestore.instance.collection('administradores').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error al cargar administradores",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No hay administradores disponibles"),
            );
          }

          final admins = snapshot.data!.docs.map((admin) {
            return UserModel.fromJson(admin.data());
          }).toList();

          return BlocBuilder<AdminUidCubit, String>(
            builder: (context, state) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: admins.length,
                itemBuilder: (context, index) {
                  final admin = admins[index];

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<AdminUidCubit>()
                          .changeAdminUid(state == admin.uid ? "" : admin.uid);
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: state == admin.uid
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 5,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: admin.profilePicture.isNotEmpty
                                ? NetworkImage(admin.profilePicture)
                                : const AssetImage(
                                    "assets/images/no_profile_image.jpg",
                                  ) as ImageProvider,
                            radius: 35,
                          ),
                        ),
                        Text(
                          admin.name,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
