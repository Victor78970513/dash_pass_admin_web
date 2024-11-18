import 'package:dash_pass_web/features/auth/presentation/pages/sign_in_page.dart';
import 'package:dash_pass_web/features/home/cubit/navigation_cubit.dart';
import 'package:dash_pass_web/features/reports/presentation/pages/reports_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/pages/tolls_page.dart';
import 'package:dash_pass_web/features/users/presentation/pages/users_page.dart';
import 'package:dash_pass_web/features/vehicles/presentation/pages/vehicles_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LateralNavigatorBar extends StatelessWidget {
  const LateralNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      width: size.width * 0.2,
      decoration: BoxDecoration(
        color: const Color(0xFF1C3C63),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: SizedBox(
                height: 120,
                width: 300,
                child: SvgPicture.asset(
                  "assets/logos/dash_pass.svg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const LateralNavigatorItem(
            index: 0,
            title: "Gestión de Usuarios",
            icon: Icons.person_outline,
            path: UsersPage.name,
          ),
          const LateralNavigatorItem(
            title: "Monitoreo Vehicular",
            icon: Icons.directions_car_outlined,
            path: VehiclesPage.name,
            index: 1,
          ),
          const LateralNavigatorItem(
            title: "Gestión de Peajes",
            icon: FontAwesomeIcons.road,
            path: TollsPage.name,
            index: 2,
          ),
          const LateralNavigatorItem(
            title: "Informes y Reportes",
            icon: Icons.insert_chart_outlined,
            path: ReportsPage.name,
            index: 3,
          ),
          const Spacer(),
          const LateralNavigatorItem(
            title: "Cerrar Sesión",
            icon: Icons.logout,
            path: SignInPage.name,
            index: 4,
            show: false,
          ),
          const SizedBox(height: 20),
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
    final isSelected = index == currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          InkWell(
            onTap: onTap ??
                () {
                  context.go(path);
                  context.read<NavigationCubit>().changeNavigationIndex(index);
                },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isSelected && show)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24, height: 1),
            ),
        ],
      ),
    );
  }
}
