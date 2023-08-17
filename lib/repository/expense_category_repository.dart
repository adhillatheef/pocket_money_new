import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pocket_money_new/repository/expense_category_model.dart';


class ExpenseRepository{

  static Box<ExpenseCategoryModel> getExpenseCategories() => Hive.box('expenseCategories');
  List<ExpenseCategoryModel> get expenseCategories{
    return getExpenseCategories().values.toList();
  }

  addExpenseCategory({required String id, required String categoryName}){
    final expenseCategory = ExpenseCategoryModel(id: id, categoryName: categoryName);
    final box = getExpenseCategories();
    box.add(expenseCategory);
    debugPrint("Expense Category added");
  }

  updateExpenseCategory({
    required ExpenseCategoryModel expenseCategoryModel,
    required String id,
    required String categoryName}){
    expenseCategoryModel.id = id;
    expenseCategoryModel.categoryName = categoryName;
    debugPrint("Expense category updated");
  }

  delete(ExpenseCategoryModel expenseCategoryModel) {
    expenseCategoryModel.delete();
    debugPrint("Expense category deleted");
  }

  clearData(){
    final box = getExpenseCategories();
    box.clear();
  }
}