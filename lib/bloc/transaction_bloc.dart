import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/model.dart';
import '../repository/repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final Repository _transactionRepository;
  TransactionBloc(this._transactionRepository) : super(TransactionState(transactions:_transactionRepository.totalTransactions)) {
    on<AddTransactionEvent>((event, emit) async{
      debugPrint("AddTransactionEvent Called.....");
      debugPrint("amount:${event.amount}, date:${event.date}, note:${event.notes}, isIncome${event.isExpense}");
      await _transactionRepository.addTransaction(amount:event.amount ,date:event.date ,isIncome:event.isExpense,subCategory: event.subCategory,note:event.notes );
    });
    on<UpdateTransaction>((event, emit) async{
      debugPrint("UpdateTransaction Called.....");
      await _transactionRepository.updateTransaction(amount:event.amount ,date:event.date ,isIncome:event.isExpense,subCategory: event.subCategory,note:event.notes,id: event.id,transaction: event.transaction);
    });
    on<DeleteTransaction>((event, emit) async{
      debugPrint("DeleteTransaction Called.....");
      await _transactionRepository.deleteTransaction(event.transaction);
    });
    on<GetTransactions>((event,emit)async{
      debugPrint("Get Transactions");
      final transaction =  _transactionRepository.totalTransactions;
      debugPrint(transaction.toString());
      emit(TransactionState(transactions: transaction));
    });
    on<ClearData>((event,emit)async{
      debugPrint("ClearData");
      _transactionRepository.clearData();
    });
  }
}
