import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

class StorageService {
  static const String transactionBoxName = 'transactions';
  static const String budgetBoxName = 'budgets';

  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> init() async {
    if (Hive.isBoxOpen(transactionBoxName) && Hive.isBoxOpen(budgetBoxName)) {
      return;
    }
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(BudgetAdapter());
    await Hive.openBox<Transaction>(transactionBoxName);
    await Hive.openBox<Budget>(budgetBoxName);
  }

  // Transaction methods
  Future<void> addTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    await box.put(transaction.id, transaction);
  }

  Future<List<Transaction>> getAllTransactions() async {
    final box = Hive.box<Transaction>(transactionBoxName);
    return box.values.toList();
  }

  Future<List<Transaction>> getTransactionsByType(String type) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    return box.values.where((t) => t.type == type).toList();
  }

  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    return box.values.where((t) => t.category == category).toList();
  }

  Future<List<Transaction>> getRecentTransactions({int limit = 10}) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    final transactions = box.values.toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(limit).toList();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    await box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    await box.delete(id);
  }

  Future<Transaction?> getTransactionById(String id) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    return box.get(id);
  }

  Future<double> getTotalIncome() async {
    final box = Hive.box<Transaction>(transactionBoxName);
    final transactions = box.values.where((t) => t.type == 'income').toList();
    return transactions.fold<double>(0, (sum, t) => sum + t.amount);
  }

  Future<double> getTotalExpenses() async {
    final box = Hive.box<Transaction>(transactionBoxName);
    final transactions = box.values.where((t) => t.type == 'expense').toList();
    return transactions.fold<double>(0, (sum, t) => sum + t.amount);
  }

  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expenses = await getTotalExpenses();
    return income - expenses;
  }

  // Budget methods
  Future<void> addBudget(Budget budget) async {
    final box = Hive.box<Budget>(budgetBoxName);
    await box.put(budget.id, budget);
  }

  Future<List<Budget>> getAllBudgets() async {
    final box = Hive.box<Budget>(budgetBoxName);
    return box.values.toList();
  }

  Future<List<Budget>> getBudgetsForMonth(int month, int year) async {
    final box = Hive.box<Budget>(budgetBoxName);
    return box.values.where((b) => b.month == month && b.year == year).toList();
  }

  Future<Budget?> getBudgetByCategory(
    String category,
    int month,
    int year,
  ) async {
    final box = Hive.box<Budget>(budgetBoxName);
    return box.values.firstWhere(
      (b) => b.category == category && b.month == month && b.year == year,
      orElse: () => Budget(id: '', category: '', limit: 0, month: 0, year: 0),
    );
  }

  Future<void> updateBudget(Budget budget) async {
    final box = Hive.box<Budget>(budgetBoxName);
    await box.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    final box = Hive.box<Budget>(budgetBoxName);
    await box.delete(id);
  }

  Future<Budget?> getBudgetById(String id) async {
    final box = Hive.box<Budget>(budgetBoxName);
    return box.get(id);
  }

  Future<Map<String, double>> getSpendingByCategory(int month, int year) async {
    final box = Hive.box<Transaction>(transactionBoxName);
    final transactions = box.values.where((t) {
      return t.type == 'expense' &&
          t.date.month == month &&
          t.date.year == year;
    }).toList();

    final Map<String, double> spending = {};
    for (var transaction in transactions) {
      spending[transaction.category] =
          (spending[transaction.category] ?? 0) + transaction.amount;
    }

    return spending;
  }

  Future<Map<String, double>> getBudgetStatus(int month, int year) async {
    final budgets = await getBudgetsForMonth(month, year);
    final spending = await getSpendingByCategory(month, year);

    final Map<String, double> status = {};
    for (var budget in budgets) {
      final spent = spending[budget.category] ?? 0;
      final remaining = budget.limit - spent;
      status[budget.category] = remaining;
    }

    return status;
  }

  Future<void> close() async {
    await Hive.close();
  }
}
