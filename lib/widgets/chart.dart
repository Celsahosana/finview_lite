import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Chart extends StatelessWidget {
  final List<dynamic> holdings;
  const Chart({super.key, required this.holdings});

  @override
  Widget build(BuildContext context) {
    if (holdings.isEmpty) {
      return const Text('No holdings to display');
    }

    final random = Random();
    final colors = List.generate(
      holdings.length,
      (_) => Color.fromARGB(
        255,
        random.nextInt(200) + 30,
        random.nextInt(200) + 30,
        random.nextInt(200) + 30,
      ),
    );

    final totalValue = holdings.fold<double>(
      0,
      (sum, item) => sum + (item['units'] * item['current_price']),
    );

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: List.generate(holdings.length, (i) {
                final item = holdings[i];
                final value = item['units'] * item['current_price'];
                final percentage = (value / totalValue) * 100;

                return PieChartSectionData(
                  color: colors[i],
                  value: value,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: List.generate(holdings.length, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: colors[i]),
                const SizedBox(width: 6),
                Text(holdings[i]['name']),
              ],
            );
          }),
        ),
      ],
    );
  }
}
