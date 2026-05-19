import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrowthBarChart extends StatefulWidget {
  //requiere una lista de datos mensuales y etiquetas para cada mes
  final List<int> monthlyData;
  final List<String> monthLabels;
  const GrowthBarChart({
    super.key,
    required this.monthlyData,
    required this.monthLabels,
  });

  @override
  State<GrowthBarChart> createState() => _GrowthBarChartState();
}

class _GrowthBarChartState extends State<GrowthBarChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: BarChart(
        BarChartData(
          maxY: 250,
          //para mostrar el valor al tocar la barra
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => const Color.fromARGB(255, 62, 61, 61),
              tooltipBorderRadius: BorderRadius.circular(6),
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                '${widget.monthLabels[group.x]}\n', //etiqueta del mes
                const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: '${rod.toY.round()}', //el valor de la barra
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          titlesData: FlTitlesData(
            //las etiquetas del eje x se muestran debajo de cada barra
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                // se muestra la etiqueta del mes
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    widget.monthLabels[value.toInt()],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
            //las etiquetas del eje y se muestran a la izq
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 50,
                getTitlesWidget: (value, meta) => Text(
                  value == 0 ? '' : '${value.toInt()}',
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ),
            ),
            //se desactivan las otras etiquetas
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          //líneas horizontales de fondo
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50, //líneas cada 50 puntos
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: Colors.purple, strokeWidth: 0.5),
          ),
          borderData: FlBorderData(show: false),
          //se crean las barras a partir de los datos mensuales
          barGroups: widget.monthlyData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  //dibuja la primer barra
                  toY: e.value.toDouble(),
                  color: Colors.deepOrange,
                  width: 22,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    //dibuja la barra de fondo para mostrar el max
                    show: true,
                    toY: 250,
                    color: Colors.greenAccent.withOpacity(0.15),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
