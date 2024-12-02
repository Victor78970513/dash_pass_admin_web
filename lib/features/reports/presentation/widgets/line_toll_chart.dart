import 'package:dash_pass_web/models/pases_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTollChart extends StatelessWidget {
  final List<PasesModel> pases;
  const LineTollChart({super.key, required this.pases});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ingresosMensuales = _groupByMonth(pases);
    final spots = _generateSpots(ingresosMensuales);
    return SizedBox(
      height: size.height * 0.5,
      width: size.width * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.graphic_eq, color: Colors.blue, size: 28),
                SizedBox(width: 16),
                Text(
                  "Evolución de los Ingresos Mensuales por Peaje",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 10,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: _bottomTitleWidgets,
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: _leftTitleWidgets,
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                  maxY:
                      ingresosMensuales.values.reduce((a, b) => a > b ? a : b) +
                          10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple]
                              .map((color) => color.withOpacity(0.3))
                              .toList(),
                        ),
                      ),
                      showingIndicators: [
                        0,
                        1,
                        2,
                        3,
                        4,
                        5,
                        6,
                        7,
                        8,
                        9,
                        10,
                        11
                      ], // Mostrar todos los puntos
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<int, double> _groupByMonth(List<PasesModel> pases) {
    final Map<int, double> ingresosMensuales = {};

    for (var pase in pases) {
      final month = pase.createdAt.month;
      if (ingresosMensuales.containsKey(month)) {
        ingresosMensuales[month] = ingresosMensuales[month]! + pase.monto;
      } else {
        ingresosMensuales[month] = pase.monto;
      }
    }

    return ingresosMensuales;
  }

  // Función para generar los spots para la gráfica
  List<FlSpot> _generateSpots(Map<int, double> ingresosMensuales) {
    return ingresosMensuales.entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  // Funciones para personalizar los títulos de la gráfica
  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    String title = '';
    if (value == 1) {
      title = 'Ene';
    } else if (value == 2) {
      title = 'Feb';
    } else if (value == 3) {
      title = 'Mar';
    } else if (value == 4) {
      title = 'Abr';
    } else if (value == 5) {
      title = 'May';
    } else if (value == 6) {
      title = 'Jun';
    } else if (value == 7) {
      title = 'Jul';
    } else if (value == 8) {
      title = 'Ago';
    } else if (value == 9) {
      title = 'Sep';
    } else if (value == 10) {
      title = 'Oct';
    } else if (value == 11) {
      title = 'Nov';
    } else if (value == 12) {
      title = 'Dic';
    }
    return Text(title, style: style);
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    return Text('$value', style: style);
  }
}
