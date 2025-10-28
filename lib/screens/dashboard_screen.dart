import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_transactions_widget.dart';
import '../widgets/expense_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(),
              SizedBox(height: 16),
              ExpenseChart(),
              SizedBox(height: 16),
              RecentTransactionsWidget(),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
