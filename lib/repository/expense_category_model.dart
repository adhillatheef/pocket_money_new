import 'package:hive/hive.dart';
part 'expense_category_model.g.dart';

@HiveType(typeId: 2)
class ExpenseCategoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String categoryName;

  ExpenseCategoryModel({required this.id, required this.categoryName});
}