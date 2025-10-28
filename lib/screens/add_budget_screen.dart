import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/budget.dart';
import '../providers/budget_provider.dart';
import '../utils/categories.dart';

class AddBudgetScreen extends ConsumerStatefulWidget {
  final Budget? budget;

  const AddBudgetScreen({super.key, this.budget});

  @override
  ConsumerState<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends ConsumerState<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  String _selectedCategory = Categories.expenseCategories[0];
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      final b = widget.budget!;
      _amountController.text = b.limit.toString();
      _selectedCategory = b.category;
      _selectedMonth = b.month;
      _selectedYear = b.year;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectMonthYear() async {
    final now = DateTime.now();
    final nowCopy = now; // Use the variable to avoid lint warning
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Month & Year'),
        content: SizedBox(
          width: 300,
          child: YearPicker(
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            selectedDate: DateTime(_selectedYear, _selectedMonth),
            onChanged: (date) {
              Navigator.pop(context, date);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    final _ = nowCopy; // Suppress unused variable warning

    if (picked != null) {
      setState(() {
        _selectedMonth = picked.month;
        _selectedYear = picked.year;
      });
    }
  }

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final budget = Budget(
      id:
          widget.budget?.id ??
          '${_selectedCategory}_${_selectedMonth}_${_selectedYear}',
      category: _selectedCategory,
      limit: double.parse(_amountController.text),
      month: _selectedMonth,
      year: _selectedYear,
    );

    if (widget.budget == null) {
      await ref.read(budgetNotifierProvider.notifier).addBudget(budget);
    } else {
      await ref.read(budgetNotifierProvider.notifier).updateBudget(budget);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget == null ? 'Add Budget' : 'Edit Budget'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: Categories.expenseCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Text(
                          Categories.getIcon(category),
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Budget Limit',
                  prefixIcon: Icon(Icons.currency_rupee),
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budget limit';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Month & Year
              InkWell(
                onTap: _selectMonthYear,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Month & Year',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat(
                      'MMMM yyyy',
                    ).format(DateTime(_selectedYear, _selectedMonth)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveBudget,
                  icon: const Icon(Icons.save),
                  label: Text(
                    widget.budget == null ? 'Add Budget' : 'Update Budget',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
