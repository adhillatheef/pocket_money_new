import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_money_new/repository/expense_category_repository.dart';
import 'package:pocket_money_new/repository/income_category_repository.dart';

import '../repository/expense_category_model.dart';
import '../repository/income_category_model.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final IncomeRepository incomeRepository;
  final ExpenseRepository expenseRepository;
  CategoriesBloc({required this.expenseRepository, required this.incomeRepository}) : super(CategoriesState(incomeCategoryList: incomeRepository.incomeCategories, expenseCategoryList: expenseRepository.expenseCategories)) {
    on<AddIncomeCategory>((event, emit)  {
      debugPrint("Income category added");
      incomeRepository.addIncomeCategory(id: event.id, categoryName: event.categoryName);
      emit(CategoriesState(incomeCategoryList: incomeRepository.incomeCategories, expenseCategoryList: expenseRepository.expenseCategories));
    });
    on<AddExpenseCategory>((event, emit) {
      debugPrint("Expense category added");
      expenseRepository.addExpenseCategory(id: event.id, categoryName: event.categoryName);
      emit(CategoriesState(incomeCategoryList: incomeRepository.incomeCategories, expenseCategoryList: expenseRepository.expenseCategories));
    });
    on<DeleteIncomeCategory>((event, emit) {
      debugPrint("Income category deleted");
      incomeRepository.delete(event.incomeCategoryModel);
      emit(CategoriesState(incomeCategoryList: incomeRepository.incomeCategories, expenseCategoryList: expenseRepository.expenseCategories));
    });
    on<DeleteExpenseCategory>((event, emit) {
      debugPrint("Expense category deleted");
      expenseRepository.delete(event.expenseCategoryModel);
      emit(CategoriesState(incomeCategoryList: incomeRepository.incomeCategories, expenseCategoryList: expenseRepository.expenseCategories));
    });
    on<ClearCategoriesData>((event, emit){
      debugPrint("Clear category data");
      incomeRepository.clearData();
      expenseRepository.clearData();
      emit(CategoriesState(incomeCategoryList: incomeRepository.incomeCategories, expenseCategoryList: expenseRepository.expenseCategories));
    });
  }
}
