part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class AddTransactionEvent extends TransactionEvent{
  final double amount;
  final bool isExpense;
  final String subCategory;
  final String notes;
  final DateTime date;
  const AddTransactionEvent({
    required this.amount,
    required this.isExpense,
    required this.subCategory,
    required this.notes,
    required this.date});

  @override
  List<Object?> get props => [amount,isExpense,notes,date];
}

class UpdateTransaction extends TransactionEvent {
  final String id;
  final double amount;
  final bool isExpense;
  final String subCategory;
  final String notes;
  final DateTime date;
  final Transaction transaction;
  const UpdateTransaction({
    required this.id,
    required this.amount,
    required this.isExpense,
    required this.subCategory,
    required this.notes,
    required this.date,
    required this.transaction});

  @override
  List<Object?> get props => [id,amount,isExpense,notes,date,transaction];
}

class DeleteTransaction extends TransactionEvent {
  final Transaction transaction;
  const DeleteTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class GetTransactions extends TransactionEvent{
  @override
  List<Object?> get props => [];
}

class ClearData extends TransactionEvent{
  @override
  List<Object?> get props => [];
}


