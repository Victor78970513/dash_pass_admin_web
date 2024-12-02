import 'package:dash_pass_web/config/utils/pdf_generator.dart';
import 'package:dash_pass_web/features/reports/presentation/pages/graphics_page.dart';
import 'package:dash_pass_web/features/tolls/presentation/cubits/tolls/tolls_cubit.dart';
import 'package:dash_pass_web/features/users/presentation/cubits/users/users_cubit.dart';
import 'package:dash_pass_web/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsMenu extends StatelessWidget {
  static const name = "/reports-menu";
  const ReportsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.read<UsersCubit>().usersToReport;
    final tolls = context.read<TollsCubit>().tollsToReport;
    return Container(
      color: const Color(0xffF4F4F4),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuOption(context,
                  icon: Icons.bar_chart,
                  label: "Ver Gráficas",
                  onTap: () => context.goNamed(GraphicsPage.name)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuOption(
                    context,
                    icon: FontAwesomeIcons.filePdf,
                    label: "Generar Reporte de usuarios en PDF",
                    onTap: () async {
                      await TablePdfUsersApi.generateTablePDf(users);
                    },
                  ),
                  const SizedBox(width: 40),
                  _buildMenuOption(
                    context,
                    icon: FontAwesomeIcons.fileExcel,
                    label: "Generar Reporte de usuarios en Excel",
                    onTap: () async {
                      await ExcelUserApi.generateStyledExcel(users);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuOption(
                    context,
                    icon: FontAwesomeIcons.filePdf,
                    label: "Generar Reporte de pases en PDF",
                    onTap: () async {
                      await TablePdfPasesApi.generateTablePDf(pasesToReport);
                    },
                  ),
                  const SizedBox(width: 40),
                  _buildMenuOption(
                    context,
                    icon: FontAwesomeIcons.fileExcel,
                    label: "Generar Reporte de pases en Excel",
                    onTap: () async {
                      await ExcelPaseApi.generateStyledExcel(pasesToReport);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuOption(
                    context,
                    icon: FontAwesomeIcons.filePdf,
                    label: "Generar Reporte de peajes en PDF",
                    onTap: () async {
                      await TablePdfPeajesApi.generateTablePDf(tolls);
                    },
                  ),
                  const SizedBox(width: 40),
                  _buildMenuOption(
                    context,
                    icon: FontAwesomeIcons.fileExcel,
                    label: "Generar Reporte de peajes en Excel",
                    onTap: () async {
                      await ExcelTollApi.generateStyledExcel(tolls);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportOptions(BuildContext context, String reportType) {
    final users = context.read<UsersCubit>().usersToReport;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMenuOption(
          context,
          icon: FontAwesomeIcons.filePdf,
          label: "Generar Reporte de $reportType en PDF",
          onTap: () async {
            await TablePdfUsersApi.generateTablePDf(users);
          },
        ),
        const SizedBox(width: 40),
        _buildMenuOption(
          context,
          icon: FontAwesomeIcons.fileExcel,
          label: "Generar Reporte de $reportType en Excel",
          onTap: () async {
            await ExcelUserApi.generateStyledExcel(users);
          },
        ),
      ],
    );
  }

  Widget _buildMenuOption(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        decoration: BoxDecoration(
          color: const Color(0xFF1C3C63),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFBDC3C7), blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "© 2024 Dash Pass",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF1C3C63),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Todos los derechos reservados",
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF1C3C63),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
