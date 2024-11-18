import 'dart:html' as html; // Para abrir y guardar archivos en Web
import 'dart:typed_data';

import 'package:dash_pass_web/features/reports/presentation/cubit/pases_cubit.dart';
import 'package:dash_pass_web/features/reports/presentation/widgets/bar_toll_chart.dart';
import 'package:dash_pass_web/features/reports/presentation/widgets/line_toll_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

class ReportsPage extends StatefulWidget {
  static const name = '/reports-page';

  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
                    onTap: () async {
                      final state =
                          context.read<PasesCubit>().state as PasesLoaded;
                      final image1 = await screenshotController
                          .captureFromWidget(LineTollChart(pases: state.pases));
                      final image2 = await screenshotController
                          .captureFromWidget(BarTollChart(pases: state.pases));

                      // Generar PDF para web
                      final imagePdfApi =
                          ImagePdfApi(image: image1, image2: image2);
                      await imagePdfApi.generateImagePdfWeb();
                    },
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

class ImagePdfApi {
  final Uint8List image;
  final Uint8List image2;
  ImagePdfApi({required this.image, required this.image2});

  Future<void> generateImagePdfWeb() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          children: [
            pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.cover),
            pw.SizedBox(height: 20),
            pw.Image(pw.MemoryImage(image2), fit: pw.BoxFit.cover),
          ],
        ),
      ),
    );

    final data = await pdf.save();
    SaveAndOpenDocument.openPdfWeb(data, "report.pdf");
  }
}

class SaveAndOpenDocument {
  static Future<void> openPdfWeb(Uint8List data, String fileName) async {
    final blob = html.Blob([data]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName;
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }
}

class WidgetWrapper extends StatelessWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          // ignore: deprecated_member_use
          data: MediaQueryData.fromView(WidgetsBinding.instance.window),
          child: child,
        ),
      ),
    );
  }
}






// Future<void> loadJsonAndUploadToFirestore() async {
//   // Cargar el archivo JSON desde los assets
//   String jsonString = await rootBundle.loadString('data.json');

//   // Parsear el JSON
//   List<dynamic> jsonResponse = json.decode(jsonString);

//   // Obtener la instancia de Firestore
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // Iterar sobre los objetos y agregar cada uno a Firestore
//   for (var item in jsonResponse) {
//     try {
//       final idPase = FirebaseFirestore.instance.collection('pases').doc().id;
//       // Crear un nuevo documento en la colección "pases"
//       await firestore.collection('pases').doc(idPase).set({
//         'fecha_creacion': DateTime.parse(item['fecha_creacion']),
//         'id_pase': idPase,
//         'id_peaje': item['id_peaje'],
//         'id_usuario': item['id_usuario'],
//         'id_vehiculo': item['id_vehiculo'],
//         'monto': item['monto'],
//         'pago_estado': item['pago_estado'],
//       });
//       print('Pase agregado: ${item['id_pase']}');
//     } catch (e) {
//       print('Error al agregar pase: $e');
//     }
//   }
// }