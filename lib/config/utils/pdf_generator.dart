import 'package:dash_pass_web/models/pase_detalle_model.dart';
import 'package:dash_pass_web/models/toll_model.dart';
import "package:dash_pass_web/models/user_app_model.dart";
import "package:flutter/services.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';

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

class ExcelUserApi {
  static Future<void> generateStyledExcel(List<UserAppModel> users) async {
    final excel = Excel.createExcel(); // Crear archivo Excel
    final sheetName = "Usuarios";
    final Sheet sheet = excel[sheetName]; // Obtener o crear la hoja

    // Estilo de cabecera
    final headerStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 12,
      bold: true,
      // backgroundColorHex: "#D3D3D3", // Gris claro
      textWrapping: TextWrapping.WrapText,
    );

    // Agregar la cabecera
    final headers = ["Nombre", "Correo", "Carnet", "Teléfono", "Estado"];
    for (var i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Estilo de datos
    final dataStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      textWrapping: TextWrapping.WrapText,
    );

    // Agregar los datos de los usuarios
    for (var rowIndex = 0; rowIndex < users.length; rowIndex++) {
      final user = users[rowIndex];
      final data = [
        TextCellValue(user.name),
        TextCellValue(user.email),
        IntCellValue(user.carnet),
        TextCellValue("+591 ${user.phone}"),
        TextCellValue(user.acountState ? "Activo" : "Desactivado"),
      ];

      for (var columnIndex = 0; columnIndex < data.length; columnIndex++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(
              columnIndex: columnIndex, rowIndex: rowIndex + 1),
        );
        cell.value = data[columnIndex];
        cell.cellStyle = dataStyle;
      }
    }

    // Guardar y descargar el archivo
    final List<int>? bytes = excel.save();
    if (bytes != null) {
      final Uint8List data = Uint8List.fromList(bytes);
      final blob = html.Blob([data]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = "reporte_usuarios_styled.xlsx";
      anchor.click();
      html.Url.revokeObjectUrl(url);
    }
  }
}

class ExcelTollApi {
  static Future<void> generateStyledExcel(List<TollModel> tolls) async {
    final excel = Excel.createExcel(); // Crear archivo Excel
    final sheetName = "Peajes";
    final Sheet sheet = excel[sheetName]; // Obtener o crear la hoja

    // Estilo de cabecera
    final headerStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 12,
      bold: true,
      // backgroundColorHex: "#D3D3D3", // Gris claro
      textWrapping: TextWrapping.WrapText,
    );

    // Agregar la cabecera
    final headers = [
      "Nombre",
      "Correo administrador",
      "Carnet administrador",
      "Teléfono administrador",
      "Estado"
    ];
    for (var i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Estilo de datos
    final dataStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      textWrapping: TextWrapping.WrapText,
    );

    // Agregar los datos de los peajes
    for (var rowIndex = 0; rowIndex < tolls.length; rowIndex++) {
      final toll = tolls[rowIndex];
      final data = [
        TextCellValue(toll.name),
        TextCellValue(toll.adminData?.email ?? "Sin correo"),
        IntCellValue(toll.adminData?.carnet ?? 0),
        TextCellValue("+591 ${toll.adminData?.phone ?? "Sin teléfono"}"),
        TextCellValue(
            toll.adminData?.acountState ?? false ? "Activo" : "Desactivado"),
      ];

      for (var columnIndex = 0; columnIndex < data.length; columnIndex++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(
              columnIndex: columnIndex, rowIndex: rowIndex + 1),
        );
        cell.value = data[columnIndex];
        cell.cellStyle = dataStyle;
      }
    }

    // Guardar y descargar el archivo
    final List<int>? bytes = excel.save();
    if (bytes != null) {
      final Uint8List data = Uint8List.fromList(bytes);
      final blob = html.Blob([data]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = "reporte_peajes.xlsx";
      anchor.click();
      html.Url.revokeObjectUrl(url);
    }
  }
}

class ExcelPaseApi {
  static Future<void> generateStyledExcel(List<PaseDetalle> pases) async {
    final excel = Excel.createExcel(); // Crear archivo Excel
    final sheetName = "Pases";
    final Sheet sheet = excel[sheetName]; // Obtener o crear la hoja

    // Estilo de cabecera
    final headerStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 12,
      bold: true,
      // backgroundColorHex: "#D3D3D3", // Gris claro
      textWrapping: TextWrapping.WrapText,
    );

    // Agregar la cabecera
    final headers = [
      "Nombre conductor",
      "Correo",
      "Placa vehículo",
      "Tipo de vehículo",
      "Monto pagado",
      "fecha del pase"
    ];
    for (var i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Estilo de datos
    final dataStyle = CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 10,
      textWrapping: TextWrapping.WrapText,
    );

    // Agregar los datos de los pases
    for (var rowIndex = 0; rowIndex < pases.length; rowIndex++) {
      final pase = pases[rowIndex];
      final data = [
        TextCellValue(pase.usuario.name),
        TextCellValue(pase.usuario.email),
        TextCellValue(pase.vehiculo.placa),
        TextCellValue(pase.vehiculo.tipoVehiculo),
        TextCellValue(pase.monto.toString()),
        TextCellValue(
            "${pase.fechaCreacion.day}-${pase.fechaCreacion.month}-${pase.fechaCreacion.year}")
      ];

      for (var columnIndex = 0; columnIndex < data.length; columnIndex++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(
              columnIndex: columnIndex, rowIndex: rowIndex + 1),
        );
        cell.value = data[columnIndex];
        cell.cellStyle = dataStyle;
      }
    }

    // Guardar y descargar el archivo
    final List<int>? bytes = excel.save();
    if (bytes != null) {
      final Uint8List data = Uint8List.fromList(bytes);
      final blob = html.Blob([data]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = "reporte_pases.xlsx";
      anchor.click();
      html.Url.revokeObjectUrl(url);
    }
  }
}

class TablePdfUsersApi {
  static Future<void> generateTablePDf(List<UserAppModel> users) async {
    const pageSize = 26;
    final pdfFile = pw.Document();

    // Cargar el logo
    final ByteData logoData =
        await rootBundle.load("assets/logos/dash_pass_logo.png");
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Obtener la fecha actual formateada
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Dividir datos en páginas
    Map<int, List<pw.TableRow>> rows = {};
    final numberOfPages = (users.length / pageSize).ceil();

    for (var page = 0; page < numberOfPages; page++) {
      rows[page] = [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Nombre",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Correo",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Carnet",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Teléfono",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Estado",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ];

      final loopLimit = (page + 1) * pageSize > users.length
          ? users.length
          : (page + 1) * pageSize;

      for (var index = page * pageSize; index < loopLimit; index++) {
        rows[page]!.add(
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    users[index].name,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    users[index].email,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    users[index].carnet.toString(),
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    "+591 ${users[index].phone.toString()}",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    users[index].acountState ? "Activo" : "Desactivado",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    pdfFile.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 60,
                height: 60,
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                "Reporte de Usuarios",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Fecha: $currentDate",
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        build: (context) {
          return List<pw.Widget>.generate(rows.keys.length, (index) {
            return pw.Column(
              children: [
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(3),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(2),
                    4: const pw.FlexColumnWidth(1),
                  },
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: rows[index]!,
                ),
                if (index != rows.keys.length - 1) pw.SizedBox(height: 20),
              ],
            );
          });
        },
      ),
    );

    final dataToSave = await pdfFile.save();
    return SaveAndOpenDocument.openPdfWeb(dataToSave, "report.pdf");
  }
}

class TablePdfPeajesApi {
  static Future<void> generateTablePDf(List<TollModel> tolls) async {
    const pageSize = 26;
    final pdfFile = pw.Document();

    // Cargar el logo
    final ByteData logoData =
        await rootBundle.load("assets/logos/dash_pass_logo.png");
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Obtener la fecha actual formateada
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Dividir datos en páginas
    Map<int, List<pw.TableRow>> rows = {};
    final numberOfPages = (tolls.length / pageSize).ceil();

    for (var page = 0; page < numberOfPages; page++) {
      rows[page] = [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Nombre peaje",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Correo administrador",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Carnet administrador",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Teléfono administrador",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Estado",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ];

      final loopLimit = (page + 1) * pageSize > tolls.length
          ? tolls.length
          : (page + 1) * pageSize;

      for (var index = page * pageSize; index < loopLimit; index++) {
        rows[page]!.add(
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    tolls[index].name,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    tolls[index].adminData?.email ?? "Sin correo",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    tolls[index].adminData?.carnet.toString() ?? "Sin carnet",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    "+591 ${tolls[index].adminData?.phone.toString() ?? "sin telefono"}",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    (tolls[index].adminData?.acountState ?? false)
                        ? "Activo"
                        : "Desactivado",
                    style: pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    pdfFile.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 60,
                height: 60,
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                "Reporte de Peajes",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Fecha: $currentDate",
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        build: (context) {
          return List<pw.Widget>.generate(rows.keys.length, (index) {
            return pw.Column(
              children: [
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1),
                    4: const pw.FlexColumnWidth(1),
                  },
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: rows[index]!,
                ),
                if (index != rows.keys.length - 1) pw.SizedBox(height: 20),
              ],
            );
          });
        },
      ),
    );

    final dataToSave = await pdfFile.save();
    return SaveAndOpenDocument.openPdfWeb(dataToSave, "report-peajes.pdf");
  }
}

class TablePdfPasesApi {
  static Future<void> generateTablePDf(List<PaseDetalle> pases) async {
    const pageSize = 15;
    final pdfFile = pw.Document();

    // Cargar el logo
    final ByteData logoData =
        await rootBundle.load("assets/logos/dash_pass_logo.png");
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Obtener la fecha actual formateada
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Dividir datos en páginas
    Map<int, List<pw.TableRow>> rows = {};
    final numberOfPages = (pases.length / pageSize).ceil();

    for (var page = 0; page < numberOfPages; page++) {
      rows[page] = [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Nombre conductor",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Correo",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Placa vehiculo",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Tipo de vehiculo",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Monto pagado",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Center(
                child: pw.Text(
                  "Fecha del pase",
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ];

      final loopLimit = (page + 1) * pageSize > pases.length
          ? pases.length
          : (page + 1) * pageSize;

      for (var index = page * pageSize; index < loopLimit; index++) {
        rows[page]!.add(
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    pases[index].usuario.name,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    pases[index].usuario.email,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    pases[index].vehiculo.placa,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    pases[index].vehiculo.tipoVehiculo,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    pases[index].monto.toString(),
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Center(
                  child: pw.Text(
                    "${pases[index].fechaCreacion.day}-${pases[index].fechaCreacion.month}-${pases[index].fechaCreacion.year}",
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    pdfFile.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 60,
                height: 60,
              ),
              pw.SizedBox(width: 10),
              pw.Text(
                "Reporte de Peajes",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "Fecha: $currentDate",
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        build: (context) {
          return List<pw.Widget>.generate(rows.keys.length, (index) {
            return pw.Column(
              children: [
                pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(1),
                    4: const pw.FlexColumnWidth(1),
                  },
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: rows[index]!,
                ),
                if (index != rows.keys.length - 1) pw.SizedBox(height: 20),
              ],
            );
          });
        },
      ),
    );

    final dataToSave = await pdfFile.save();
    return SaveAndOpenDocument.openPdfWeb(dataToSave, "report-peajes.pdf");
  }
}
