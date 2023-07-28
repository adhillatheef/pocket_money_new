part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  final List<Transaction>? transactions;
     const TransactionState({this.transactions});

  @override
  List<Object?> get props => [transactions];

  double get totalIncome =>
      transactions!.where((transaction) => transaction.isIncome).fold<double>(0, (sum, transaction) => sum + transaction.amount!);

  double get totalExpense =>
      transactions!.where((transaction) => !transaction.isIncome).fold<double>(0, (sum, transaction) => sum + transaction.amount!);
  double get totalBalance => totalIncome - totalExpense;

  List<Transaction> getIncomeTransactions() =>
      transactions!.where((transaction) => transaction.isIncome).toList();

  List<Transaction> getExpenseTransactions() =>
      transactions!.where((transaction) => !transaction.isIncome).toList();

  List<Transaction> get recentTransaction {
    final currentDate = DateTime.now();
    final lastSevenDays = currentDate.subtract(const Duration(days: 7));
    return transactions!
        .where((tx) => tx.date!.isAfter(lastSevenDays))
        .toList();
  }
}
// class TransactionInitial extends TransactionState {
//   TransactionInitial():super(transactions: Repository().totalTransactions);
//   @override
//   List<Object> get props => [];
// }
