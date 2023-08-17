part of 'categories_bloc.dart';

class CategoriesState extends Equatable {
  final List<IncomeCategoryModel> incomeCategoryList;
  final List<ExpenseCategoryModel> expenseCategoryList;
  const CategoriesState({required this.incomeCategoryList, required this.expenseCategoryList});

  @override
  List<Object?> get props => [incomeCategoryList, expenseCategoryList];
}

// class CategoriesInitial extends CategoriesState {
//   @override
//   List<Object> get props => [];
// }
