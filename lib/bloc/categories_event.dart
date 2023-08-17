part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
}

class AddIncomeCategory extends CategoriesEvent {
  final String id;
  final String categoryName;
  const AddIncomeCategory({required this.id, required this.categoryName});
  @override
  List<Object?> get props => [];
}

class AddExpenseCategory extends CategoriesEvent {
  final String id;
  final String categoryName;
  const AddExpenseCategory({required this.id, required this.categoryName});
  @override
  List<Object?> get props => [];
}

class DeleteIncomeCategory extends CategoriesEvent{
  final IncomeCategoryModel incomeCategoryModel;
  const DeleteIncomeCategory(this.incomeCategoryModel);
  @override
  List<Object?> get props => [];
}

class DeleteExpenseCategory extends CategoriesEvent{
  final ExpenseCategoryModel expenseCategoryModel;
  const DeleteExpenseCategory(this.expenseCategoryModel);
  @override
  List<Object?> get props => [];
}

class ClearCategoriesData extends CategoriesEvent{
  const ClearCategoriesData();
  @override
  List<Object?> get props => [];
}
