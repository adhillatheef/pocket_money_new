import 'package:hive/hive.dart';

part 'income_category_model.g.dart';

@HiveType(typeId: 1)
class IncomeCategoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String categoryName;

  IncomeCategoryModel({required this.id, required this.categoryName});
}

