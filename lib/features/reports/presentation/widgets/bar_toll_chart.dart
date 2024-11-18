import 'package:dash_pass_web/models/pases_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarTollChart extends StatelessWidget {
  final List<PasesModel> pases;

  const BarTollChart({super.key, required this.pases});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<BarChartGroupData> barGroups = List.generate(12, (index) {
      int month = index + 1;
      double totalMonto = pases
          .where((pase) => pase.createdAt.month == month)
          .fold(0.0, (sum, pase) => sum + pase.monto);

      return makeGroupData(month, totalMonto);
    });

    return SizedBox(
      height: size.height * 0.5,
      width: size.width * 0.7,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.graphic_eq, color: Colors.blue, size: 28),
                  SizedBox(width: 16),
                  Text(
                    "Ingresos del Peaje por Mes",
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
                child: BarChart(
                  BarChartData(
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) {
                          return Colors.purple;
                        },
                        // tooltipBgColor: Colors.blueAccent,
                      ),
                      touchCallback: (p0, p1) {},
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: getTitles,
                          reservedSize: 38,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 40,
                          interval: 100,
                          showTitles: true,
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.blueGrey, width: 1),
                    ),
                    barGroups: barGroups,
                    gridData: FlGridData(show: true, drawHorizontalLine: true),
                    alignment: BarChartAlignment.spaceAround,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int month, double monto) {
    return BarChartGroupData(
      x: month - 1,
      barRods: [
        BarChartRodData(
          toY: monto,
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(6),
          width: 22,
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        months[value.toInt()],
        style: style,
      ),
    );
  }
}
