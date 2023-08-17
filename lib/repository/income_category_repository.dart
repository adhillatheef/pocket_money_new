import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pocket_money_new/repository/income_category_model.dart';


class IncomeRepository{

  static Box<IncomeCategoryModel> getIncomeCategories() => Hive.box('incomeCategories');
  List<IncomeCategoryModel> get incomeCategories{
    return getIncomeCategories().values.toList();
  }

  addIncomeCategory({required String id, required String categoryName}){
    final incomeCategory = IncomeCategoryModel(id: id, categoryName: categoryName);
    final box = getIncomeCategories();
    box.add(incomeCategory);
    debugPrint("Income Category added");
  }

  updateIncomeCategory({
    required IncomeCategoryModel incomeCategoryModel,
    required String id,
    required String categoryName}){
    incomeCategoryModel.id = id;
    incomeCategoryModel.categoryName = categoryName;
    debugPrint("Income category updated");
  }

  delete(IncomeCategoryModel incomeCategoryModel) {
    incomeCategoryModel.delete();
    debugPrint("Income category deleted");
  }

  clearData(){
    final box = getIncomeCategories();
    box.clear();
  }
}