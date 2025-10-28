import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/categories.dart';
import 'add_budget_screen.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final budgetsAsync = ref.watch(budgetsByMonthProvider(now));
    final spendingAsync = ref.watch(expenseByCategoryProvider(now));
    final budgetStatusAsync = ref.watch(budgetStatusProvider(now));

    return Scaffold(
      appBar: AppBar(
        title: Text('Budgets - ${DateFormat('MMMM yyyy').format(now)}'),
      ),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No budgets set for this month',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to set your first budget',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return spendingAsync.when(
            data: (spending) {
              return budgetStatusAsync.when(
                data: (status) {
                  return ListView.builder(
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      final budget = budgets[index];
                      final spent = spending[budget.category] ?? 0;
                      final remaining = status[budget.category] ?? budget.limit;
                      final percentage = (spent / budget.limit).clamp(0.0, 1.0);
                      final isOverBudget = spent > budget.limit;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isOverBudget
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            child: Text(
                              Categories.getIcon(budget.category),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          title: Text(
                            budget.category,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isOverBudget ? Colors.red : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${NumberFormat('#,##,###').format(spent)} / ₹${NumberFormat('#,##,###').format(budget.limit)}',
                                style: TextStyle(
                                  color: isOverBudget
                                      ? Colors.red
                                      : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Remaining: ₹${NumberFormat('#,##,###').format(remaining)}',
                                style: TextStyle(
                                  color: isOverBudget
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddBudgetScreen(budget: budget),
                                ),
                              );
                            },
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Budget'),
                                content: const Text(
                                  'Are you sure you want to delete this budget?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(budgetNotifierProvider.notifier)
                                          .deleteBudget(budget.id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error loading status: $error'),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error loading spending: $error'),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $error'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBudgetScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Budget'),
      ),
    );
  }
}
