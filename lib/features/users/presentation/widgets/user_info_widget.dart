import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/pages/edit_user_page.dart';
import 'package:dash_pass_web/models/user_app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

List<BoxShadow> boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: const Offset(0, 5),
    blurRadius: 5,
    blurStyle: BlurStyle.inner,
  ),
];

class UserInfoWidget extends StatelessWidget {
  final UserAppModel user;
  const UserInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final dataTextStyle = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: boxShadow,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 30, top: 24, bottom: 24),
                child: Row(
                  children: [
                    // Nombre
                    Expanded(
                      flex: 2,
                      child: Text(
                        user.name,
                        style: dataTextStyle,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Email
                    Expanded(
                      flex: 2,
                      child: Text(
                        user.email,
                        style: dataTextStyle,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Teléfono
                    Expanded(
                      flex: 2,
                      child: Text(
                        "+591 ${user.phone}",
                        style: dataTextStyle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Rol
                    Expanded(
                      flex: 2,
                      child: Text(
                        user.rolId == 1
                            ? "Super administrador"
                            : user.rolId == 2
                                ? "Administrador"
                                : "Conductor",
                        style: dataTextStyle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Fecha
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}",
                        style: dataTextStyle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Estado
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: user.acountState
                              ? const Color.fromRGBO(42, 63, 129, 1)
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          user.acountState ? "Activado" : "Desactivado",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -6,
                top: 24,
                child: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      onPressed: () {
                        final RenderBox button =
                            context.findRenderObject() as RenderBox;
                        final position = button.localToGlobal(
                            Offset.zero); // Obtiene la posición global

                        showMenu(
                          context: context,
                          color: Colors.white,
                          position: RelativeRect.fromLTRB(
                            position.dx,
                            position.dy +
                                button.size.height, // Justo debajo del botón
                            50,
                            0,
                          ),
                          items: [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Editar',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            PopupMenuItem(
                              value: 'deactivate',
                              child: Text(
                                  user.acountState == false
                                      ? "Activar"
                                      : 'Desactivar',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ).then((value) {
                          if (value == 'edit') {
                            context.goNamed(
                              EditUserPage.name,
                              extra: {
                                "user": user,
                              },
                            );
                          } else if (value == 'deactivate') {
                            context.read<UsersCubit>().updateUserState(
                                  value: !user.acountState,
                                  uid: user.uid,
                                );
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
