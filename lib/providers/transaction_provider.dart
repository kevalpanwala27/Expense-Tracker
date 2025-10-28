import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final transactionsProvider = StreamProvider<List<Transaction>>((ref) async* {
  final storageService = ref.read(storageServiceProvider);
  yield* Stream.periodic(
    const Duration(seconds: 1),
    (_) => storageService.getAllTransactions(),
  ).asyncMap((_) => storageService.getAllTransactions());
});

final recentTransactionsProvider = FutureProvider<List<Transaction>>((
  ref,
) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getRecentTransactions(limit: 10);
});

final transactionsByTypeProvider =
    FutureProvider.family<List<Transaction>, String>((ref, type) async {
      final storageService = ref.read(storageServiceProvider);
      return storageService.getTransactionsByType(type);
    });

final totalIncomeProvider = FutureProvider<double>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getTotalIncome();
});

final totalExpensesProvider = FutureProvider<double>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getTotalExpenses();
});

final balanceProvider = FutureProvider<double>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getBalance();
});

final expenseByCategoryProvider =
    FutureProvider.family<Map<String, double>, DateTime>((ref, date) async {
      final storageService = ref.read(storageServiceProvider);
      return storageService.getSpendingByCategory(date.month, date.year);
    });

class TransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final StorageService _storageService;

  TransactionNotifier(this._storageService)
    : super(const AsyncValue.data(null));

  Future<void> addTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.addTransaction(transaction);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.updateTransaction(transaction);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.deleteTransaction(id);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<void>>((ref) {
      final storageService = ref.watch(storageServiceProvider);
      return TransactionNotifier(storageService);
    });
