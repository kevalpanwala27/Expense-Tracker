import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../utils/categories.dart';

class ExpenseChart extends ConsumerWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseByCategoryAsync = ref.watch(
      expenseByCategoryProvider(DateTime.now()),
    );

    return expenseByCategoryAsync.when(
      data: (expenseByCategory) {
        if (expenseByCategory.isEmpty) {
          return const Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  'No expenses this month',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        final categories = expenseByCategory.keys.toList();
        final amounts = expenseByCategory.values.toList();

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expenses by Category',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: amounts.reduce((a, b) => a > b ? a : b) * 1.2,
                      barGroups: List.generate(categories.length, (index) {
                        final colorValues = Categories.getColor(
                          categories[index],
                        );
                        final color = Color.fromRGBO(
                          colorValues[1],
                          colorValues[2],
                          colorValues[3],
                          1.0,
                        );
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: amounts[index],
                              color: color,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= categories.length) {
                                return const Text('');
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  Categories.getIcon(categories[value.toInt()]),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          axisNameSize: 0,
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          axisNameSize: 0,
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          axisNameSize: 0,
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(categories.length, (index) {
                    final colorValues = Categories.getColor(categories[index]);
                    final color = Color.fromRGBO(
                      colorValues[1],
                      colorValues[2],
                      colorValues[3],
                      1.0,
                    );
                    return _LegendItem(
                      icon: Categories.getIcon(categories[index]),
                      label: categories[index],
                      amount: amounts[index],
                      color: color,
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String icon;
  final String label;
  final double amount;
  final Color color;

  const _LegendItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
