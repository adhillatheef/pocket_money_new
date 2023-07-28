
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

import 'model.dart';
class CategoryListDataModel {
  String category;
  IconData categoryIcon;
  bool isIncome;
  CategoryListDataModel({required this.category, required this.isIncome, required this.categoryIcon});
}

class Repository{
  static Box<Transaction> getTransactions() => Hive.box('transactions');
  List<Transaction> get totalTransactions{
    return getTransactions().values.toList();
  }


  addTransaction({
    required double amount,
    required bool isIncome,
    required String subCategory,
    required DateTime date,
    required String note}) {
    var id = const Uuid().v4();
    final transaction = Transaction(id: id,amount: amount,isIncome: isIncome,subCategory: subCategory,note:note,date: date);
    final box = getTransactions();
    box.add(transaction);
    debugPrint("Transaction added");
  }

  updateTransaction(
      { required Transaction transaction,
        required String id,
        required double amount,
        required bool isIncome,
        required String subCategory,
        required DateTime date,
        required String note}) {
    transaction.id = id;
    transaction.amount = amount;
    transaction.date = date;
    transaction.isIncome = isIncome;
    transaction.subCategory = subCategory;
    transaction.note = note;
    transaction.save();
    debugPrint("Transaction updated");
  }

  deleteTransaction(Transaction transaction) {
    transaction.delete();
    debugPrint("Transaction deleted");
  }

  clearData(){
    final box = getTransactions();
    box.clear();
  }
}

