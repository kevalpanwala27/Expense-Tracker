import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);

    return balanceAsync.when(
      data: (balance) {
        final incomeAsync = ref.watch(totalIncomeProvider);
        final expensesAsync = ref.watch(totalExpensesProvider);

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Balance',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${NumberFormat('#,##,###').format(balance)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    incomeAsync.when(
                      data: (income) => _StatItem(
                        label: 'Income',
                        amount: income,
                        color: Colors.green,
                        icon: Icons.arrow_downward,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error'),
                    ),
                    incomeAsync.when(
                      data: (income) => expensesAsync.when(
                        data: (expenses) => _StatItem(
                          label: 'Expenses',
                          amount: expenses,
                          color: Colors.red,
                          icon: Icons.arrow_upward,
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('Error'),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            Text(
              '₹${NumberFormat('#,##,###').format(amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
