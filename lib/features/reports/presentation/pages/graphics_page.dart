import 'package:dash_pass_web/features/reports/presentation/cubit/pases_cubit.dart';
import 'package:dash_pass_web/features/reports/presentation/widgets/bar_toll_chart.dart';
import 'package:dash_pass_web/features/reports/presentation/widgets/line_toll_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';

class GraphicsPage extends StatefulWidget {
  static const name = '/reports-page';

  const GraphicsPage({super.key});

  @override
  State<GraphicsPage> createState() => _GraphicsPageState();
}

class _GraphicsPageState extends State<GraphicsPage> {
  final screenshotController = ScreenshotController();

  @override
  void initState() {
    context.read<PasesCubit>().fetchPases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ingresos = context.watch<PasesCubit>().ingresosTotales;
    return Container(
      color: const Color(0xffF4F4F4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Informes y Reportes",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  "Ingresos Totales",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Bs. $ingresos",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () async {},
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C3C63),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.filePdf,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Guardar en PDF",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PasesCubit, PasesState>(
              builder: (context, state) {
                switch (state) {
                  case PasesInitial():
                  case PasesLoading():
                    return const Center(child: CircularProgressIndicator());
                  case PasesLoaded(pases: final pases):
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          LineTollChart(pases: pases),
                          BarTollChart(pases: pases),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  case PasesError():
                    return const Center(
                      child: Text("Error al traer la data de pases"),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
