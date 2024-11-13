import 'package:dash_pass_web/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dash_pass_web/features/home/cubit/navigation_cubit.dart';
import 'package:dash_pass_web/features/reports/presentation/pages/reports_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/tolls_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:dash_pass_web/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LateralNavigatorBar extends StatelessWidget {
  const LateralNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 300,
      color: const Color.fromRGBO(42, 39, 98, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: SizedBox(
                height: 100,
                width: 300,
                child: SvgPicture.asset(
                  "assets/logos/dash_pass.svg",
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const LateralNavigatorItem(
            index: 0,
            title: "Gestion de Usuarios",
            icon: Icons.person,
            path: UsersPage.name,
          ),
          const LateralNavigatorItem(
            title: "Monitoreo Vehicular",
            icon: Icons.car_crash_sharp,
            path: VehiclesPage.name,
            index: 1,
          ),
          const LateralNavigatorItem(
            title: "Gestion de Peajes",
            icon: Icons.trolley,
            path: TollsPage.name,
            index: 2,
          ),
          const LateralNavigatorItem(
            title: "Informes y Reportes",
            icon: Icons.auto_graph_sharp,
            path: ReportsPage.name,
            index: 3,
          ),
          const Spacer(),
          const LateralNavigatorItem(
            title: "Cerrar Sesion",
            icon: Icons.logout,
            path: SignInPage.name,
            index: 4,
            show: false,
          ),
        ],
      ),
    );
  }
}

class LateralNavigatorItem extends StatelessWidget {
  final String title;
  final String path;
  final int index;
  final IconData icon;
  final Function()? onTap;
  final bool show;
  const LateralNavigatorItem({
    super.key,
    required this.title,
    required this.icon,
    required this.path,
    required this.index,
    this.onTap,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationCubit>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap ??
                () {
                  context.go(path);
                  context.read<NavigationCubit>().changeNavigationIndex(index);
                },
            child: Container(
              decoration: BoxDecoration(
                color: index == currentIndex ? Colors.red : Colors.transparent,
                gradient: index == currentIndex
                    ? const LinearGradient(
                        colors: [
                          Color.fromRGBO(81, 73, 183, 1),
                          Color.fromRGBO(138, 124, 190, 1)
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 25,
                    ),
                    const SizedBox(width: 20),
                    Text(title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
            ),
          ),
          if (index != currentIndex && show)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: Colors.white),
            )
        ],
      ),
    );
  }
}
