import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminListWidget extends StatelessWidget {
  const AdminListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adminUID = context.watch<AdminUidCubit>().state;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selecciona un administrador para el peaje",
              style: GoogleFonts.poppins(
                color: const Color(0xFF26374D),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              width: double.infinity,
              child: BlocBuilder<UsersCubit, UsersState>(
                  bloc: UsersCubit()..fetchUsersWithFilters(true, 2),
                  builder: (context, state) {
                    switch (state) {
                      case UsersInitial():
                      case UsersLoading():
                        return const Center(child: CircularProgressIndicator());
                      case UsersLoaded(users: final users):
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final admin = users[index];

                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<AdminUidCubit>()
                                    .changeAdminUid(admin.uid);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: adminUID == admin.uid
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: admin
                                              .profilePicture.isNotEmpty
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
                      case UsersError():
                        return const Center(
                          child: Text("ERROR"),
                        );
                    }
                  }),
            ),
          ],
        ));
  }
}
