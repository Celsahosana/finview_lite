import 'package:flutter/material.dart';

class HoldingTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool showPercentage;

  const HoldingTile({super.key, required this.data, required this.showPercentage,});

  @override
  Widget build(BuildContext context) {
    final currentValue = ( data ['current_price'] * data['units']);
    final gainLoss = currentValue - (data['units'] * data['avg_cost']);
    final gainLossPercentage =  (gainLoss / (data['units'] * data['avg_cost'])) * 100;

      final displayValue = showPercentage
        ? '${gainLossPercentage.toStringAsFixed(1)}%'
        : '${gainLoss.abs().toStringAsFixed(0)}';

    return Card(
      margin: EdgeInsets.symmetric( vertical: 6),
      child: ListTile(
        title: Text(data['name']),
        subtitle: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: [
              TextSpan(text: 'Units: ${data['units']} | Avg Cost: ${data['avg_cost']} | '),
              TextSpan(
                text: 'Gain/Loss: $displayValue',
                style: TextStyle(
                  color: gainLoss >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        trailing: Text('Value: ${currentValue.toStringAsFixed(2)}'),
      ),
    );
  }
}