import 'dart:convert';
import '../widgets/holding_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
Map<String, dynamic> user = {};
List<dynamic> holdings = [];
String sortBy = 'name';
final items = ['name', 'value', 'gain'];
bool showPercentage = false;

  @override 
  void initState() {
    super.initState();
    checkLoginStatus();
    loadData();
  }

  Future<void> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (!isLoggedIn && mounted) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}

  Future<void> loadData() async {
    final jsonString = await rootBundle.loadString('portfolio.json');
    final data = jsonDecode(jsonString);
    setState(() {
      user = data['user']; 
      holdings = data['holdings'];

      final totalValue = holdings.fold<double>(
        0,
        (sum, item) => sum + (item['units'] * item['current_price'])
      );

      user['portfolio_value'] = totalValue;

      final gainValue = holdings.fold<double>(
        0,
        (sum , item) {
          final diff = sum + (item['units'] * (item['current_price'] - item['avg_cost']));
          return diff > 0 
          ? sum + (item['units'] * diff) 
          : sum;
          }
      );

      user['total_gain'] = gainValue;

      final lossValue = holdings.fold<double>(
       0,
       (sum, item) {
         final diff = item['current_price'] - item['avg_cost'];
        return diff < 0 ? sum + (item['units'] * diff.abs()) : sum;
      },
    );

    user['total_loss'] = lossValue;

    final netGain = holdings.fold<double>(
      0,
      (sum, item) => sum + (item['units'] * (item['current_price'] - item['avg_cost'])),
    );

    user['net_gain'] = netGain;

    });
  }

  void sortHoldings() {
  setState(() {
    if (sortBy == 'name') {
      holdings.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (sortBy == 'value') {
      holdings.sort((a, b) {
        final aValue = a['units'] * a['current_price'];
        final bValue = b['units'] * b['current_price'];
        return bValue.compareTo(aValue); 
      });
    } else if (sortBy == 'gain') {
      holdings.sort((a, b) {
        final aGain = (a['current_price'] - a['avg_cost']) * a['units'];
        final bGain = (b['current_price'] - b['avg_cost']) * b['units'];
        return bGain.compareTo(aGain); 
      });
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text('FinView Lite'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: DropdownButton<String>(
              value: sortBy,
              items: items.map((option) {
                return DropdownMenuItem(
                  value :option,
                   child: Text(option),
                   ); 
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                    sortHoldings();
                  });
                },
              ),
            ),
              Row(
                children: [
                  const Text('₹'),
                  Switch(
                    value: showPercentage,
                    onChanged: (value) {
                      setState(() {
                        showPercentage = value;
                      });
                    },
                  ),
                  const Text('%'),
                  const SizedBox(width: 10),
              ])        
          ],
        ),

      body: holdings.isEmpty && user.isEmpty
      ? const Center(child: CircularProgressIndicator())
      : holdings.isEmpty
        ?const Center(
            child: Text(
              'No holdings available.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ) 
        : Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(' Hello, ${user['name']}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Portfolio Value: ₹${user['portfolio_value']}'),
            Text(
              'Total ${user['net_gain'] > 0 ? "Gain" : "Loss"}: ₹${user['net_gain'].abs()}',
                style: TextStyle(
                color: user['net_gain'] > 0 ? Colors.green : Colors.red,
                ),
              ),
            const SizedBox(height: 16),

            Chart(holdings: holdings),
            const SizedBox(height: 16),
            const Text('Holdings:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(child: ListView.builder(
              itemCount: holdings.length,
              itemBuilder: (context, i) => HoldingTile(data: holdings[i],
              showPercentage: showPercentage,)))
          ],
        ),
        )
      );
  }
}